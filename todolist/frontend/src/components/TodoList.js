import React, { useState, useEffect } from 'react';
import TodoForm from './TodoForm';
import Todo from './Todo';
import { completeStorageTodo, createStorageTodo, deleteStorageTodo, getStorageTodos, updateStorageTodo } from '../api';

function TodoList() {
    const [todos, setTodos] = useState([]);

    useEffect(() => {
        async function fetchData() {
            const storageTodos = await getStorageTodos();

            if (storageTodos) {
                setTodos(storageTodos)
            }
        }
        fetchData();
    }, []);

    const addTodo = async todo => {
        if (!todo.description || /^\s*$/.test(todo.description)) {
            return
        }

        await createStorageTodo({
            description: todo.description
        });

        const storageTodos = await getStorageTodos();
        setTodos(storageTodos);
    };

    const updateTodo = async (todoId, newValue) => {
        if (!newValue.description || /^\s*$/.test(newValue.description)) {
            return
        }
        await updateStorageTodo(todoId, newValue)
        const storageTodos = await getStorageTodos();
        setTodos(storageTodos);
    }

    const removeTodo = async id => {
        await deleteStorageTodo(id);

        const storageTodos = await getStorageTodos();
        setTodos(storageTodos);
    };

    const completeTodo = async id => {
        await completeStorageTodo(id);
        const storageTodos = await getStorageTodos();
        setTodos(storageTodos);
    };

    return (
        <div className="todo-context">
            <h1>What's the Plan for Today?</h1>
            <TodoForm onSubmit={addTodo} />
            <Todo todos={todos} completeTodo={completeTodo} removeTodo={removeTodo} updateTodo={updateTodo} />
        </div>
    );
}

export default TodoList;
