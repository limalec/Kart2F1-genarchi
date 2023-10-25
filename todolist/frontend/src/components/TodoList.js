import React, { useState, useEffect } from 'react';
import TodoForm from './TodoForm';
import Todo from './Todo';
import { completeStorageTodo, createStorageTodo, deleteStorageTodo, getStorageTodos, updateStorageTodo } from '../api';

function TodoList() {
    const [todos, setTodos] = useState([]);
    const LOCAL_STORAGE_KEY = "react-do-list-todos";
    
    useEffect(() => {
        async function fetchData() {
            const storageTodos = await getStorageTodos();
            console.log(storageTodos)

            if (storageTodos) {
                setTodos(storageTodos)
            }
        }
        try {
            fetchData();
        } catch (e) {
            console.log(e);
            const storageTodos = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY));

            if (storageTodos) {
                setTodos(storageTodos)
            }
        }
    }, []);

    useEffect(() => {
        localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(todos));
    }, [todos]);

    const addTodo = async todo => {
        if (!todo.description || /^\s*$/.test(todo.description)) {
            return
        }

        try {
            await createStorageTodo({
                description: todo.description
            });
            
            const storageTodos = await getStorageTodos();
            setTodos(storageTodos);
        } catch (e) {
            console.log(e);

            const newTodos = [todo, ...todos];
            setTodos(newTodos);
        }
    };

    const updateTodo = async (todoId, newValue) => {
        if (!newValue.description || /^\s*$/.test(newValue.description)) {
            return
        }
        try {
            await updateStorageTodo(todoId, {
                description: newValue.description
            });
            const storageTodos = await getStorageTodos();
            setTodos(storageTodos);
        } catch(e) {
            console.log(e);
            const updatedTodos = [...todos].map(item => (item._id === todoId ? newValue : item));

            setTodos(updatedTodos);
        }
    }

    const removeTodo = async id => {
        try {
            await deleteStorageTodo(id);
            const storageTodos = await getStorageTodos();
            setTodos(storageTodos);
        } catch(e) {
            console.log(e);
            const removeArr = [...todos].filter(todo => todo._id !== id);

            setTodos(removeArr);
        }
    };

    const completeTodo = async id => {
        try {
            await completeStorageTodo(id);
            const storageTodos = await getStorageTodos();
            setTodos(storageTodos);
        } catch(e) {
            console.log(e);
            const updatedTodos = todos.map(todo => {
                if (todo.id === id) {
                    todo.isComplete = !todo.isComplete;
                }
                return todo;
            });
            setTodos(updatedTodos);
        }
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
