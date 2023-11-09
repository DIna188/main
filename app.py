from flask import Flask, request, jsonify, render_template
import json
import os

tasks_file = os.path.abspath('/full/path/to/tasks.json')
app = Flask(__name)
tasks_file = 'tasks.json'

# Hjälpfunktion för att läsa uppgifter från tasks.json
def read_tasks_from_file():
    if os.path.exists(tasks_file):
        with open(tasks_file, 'r') as file:
            tasks = json.load(file)
        return tasks
    else:
        return []

# Hjälpfunktion för att spara uppgifter till tasks.json
def save_tasks_to_file(tasks):
    with open(tasks_file, 'w') as file:
        json.dump(tasks, file, indent=2)

@app.route('/')
def index():
    tasks = read_tasks_from_file()
    return render_template('index.html', tasks=tasks)

@app.route('/tasks', methods=['GET'])
def get_tasks():
    completed_param = request.args.get('completed')
    tasks = read_tasks_from_file()
    if completed_param == 'true':
        tasks = [task for task in tasks if task['completed']]
    elif completed_param == 'false':
        tasks = [task for task in tasks if not task['completed']]
    return jsonify(tasks)

@app.route('/tasks', methods=['POST'])
def add_task():
    try:
        data = request.get_json()
        if 'title' not in data or 'completed' not in data:
            return jsonify({'error': 'Bad Request', 'message': 'Title and completed fields are required'}), 400
        tasks = read_tasks_from_file()
        tasks.append(data)
        save_tasks_to_file(tasks)
        return jsonify({'message': 'Task added successfully'})
    except Exception as e:
        return jsonify({'error': 'Internal Server Error', 'message': str(e)}), 500

@app.route('/tasks/<int:task_id>', methods=['GET'])
def get_task(task_id):
    tasks = read_tasks_from_file()
    if 0 <= task_id < len(tasks):
        return jsonify(tasks[task_id])
    return jsonify({'error': 'Not Found', 'message': 'Task not found'}), 404

@app.route('/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    tasks = read_tasks_from_file()
    if 0 <= task_id < len(tasks):
        del tasks[task_id]
        save_tasks_to_file(tasks)
        return jsonify({'message': 'Task deleted successfully'})
    return jsonify({'error': 'Not Found', 'message': 'Task not found'}), 404

@app.route('/tasks/<int:task_id>', methods=['PUT'])
def update_task(task_id):
    try:
        data = request.get_json()
        if 'title' not in data or 'completed' not in data:
            return jsonify({'error': 'Bad Request', 'message': 'Title and completed fields are required'}), 400
        tasks = read_tasks_from_file()
        if 0 <= task_id < len(tasks):
            tasks[task_id] = data
            save_tasks_to_file(tasks)
            return jsonify({'message': 'Task updated successfully'})
        return jsonify({'error': 'Not Found', 'message': 'Task not found'}), 404
    except Exception as e:
        return jsonify({'error': 'Internal Server Error', 'message': str(e)}), 500



@app.route('/tasks/<int:task_id>/complete', methods=['PUT'])
def mark_task_as_completed(task_id):
    tasks = read_tasks_from_file()
    if 0 <= task_id < len(tasks):
        tasks[task_id]['completed'] = True
        save_tasks_to_file(tasks)
        return jsonify({'message': 'Task marked as completed'})
    return jsonify({'error': 'Not Found', 'message': 'Task not found'}), 404

@app.route('/tasks/categories/', methods=['GET'])
def get_categories():
    tasks = read_tasks_from_file()
    categories = set(task.get('category', 'Uncategorized') for task in tasks)
    return jsonify(list(categories))

@app.route('/tasks/categories/<category_name>', methods=['GET'])
def get_tasks_by_category(category_name):
    tasks = read_tasks_from_file()
    filtered_tasks = [task for task in tasks if task.get('category', 'Uncategorized') == category_name]
    return jsonify(filtered_tasks)

if __name__ == '__main__':
    app.run(debug=True)
