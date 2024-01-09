import React, { useState, useEffect } from 'react';
import TodoForm from './TodoForm';
import Todo from './Todo';
import env from 'react-dotenv';
import { completeStorageTodo, createStorageTodo, deleteStorageTodo, getStorageTodos, refreshStorageTodos, updateStorageTodo } from '../api';

import { io } from "socket.io-client";

const socket = io(env.API_URL);

function TodoList() {
    const [isConnected, setIsConnected] = useState(socket.connected);
    const [todos, setTodos] = useState([]);
    const LOCAL_STORAGE_KEY = "react-do-list-todos";
    
    useEffect(() => {
        socket.on("connect", () => {
            console.log("connected");
            setIsConnected(true);
        });
        socket.on("disconnect", () => {
            console.log("disconnected");
            setIsConnected(false);
        });

        async function fetchData() {
            const storageTodos = await getStorageTodos();
            console.log(storageTodos)

            if (storageTodos) {
                setTodos(storageTodos)
            }
        }
        try {
            if (isConnected){
                fetchData();
            }
            else {
                const storageTodos = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY));
                if (storageTodos) {
                    setTodos(storageTodos)
                }
            }
        } catch (e) {
            console.log(e); 
        }

        return () => {
            socket.off("connect");
            socket.off("disconnect");
        };
    }, []);

    useEffect(() => {
        console.log("isConnected", isConnected);
        async function fetchData() {
            setTodos(await refreshStorageTodos(todos));
        }
        try {
            // console.log("todos ", todos);
            if (isConnected) {
                fetchData();
            }
        } catch (e) {
            console.log(e);
        }
    }, [isConnected]);

    useEffect(() => {
        localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(todos));
    }, [todos]);

    const addTodo = async todo => {
        if (!todo.description || /^\s*$/.test(todo.description)) {
            return
        }

        try {
            if (isConnected) {
                await createStorageTodo({
                    description: todo.description
                });
                
                const storageTodos = await getStorageTodos();
                setTodos(storageTodos);
            } else {
                const newTodos = [todo, ...todos];
                setTodos(newTodos);
            }
        } catch (e) {
            console.log(e);
        }
    };

    const updateTodo = async (todoId, newValue) => {
        if (!newValue.description || /^\s*$/.test(newValue.description)) {
            return
        }
        try {
            if (isConnected) {
                await updateStorageTodo(todoId, {
                    description: newValue.description
                });
                const storageTodos = await getStorageTodos();
                setTodos(storageTodos);
            } else {
                const updatedTodos = [...todos].map(item => (item._id === todoId ? newValue : item));

                setTodos(updatedTodos);
            }
        } catch(e) {
            console.log(e);
        }
    }

    const removeTodo = async id => {
        try {
            if (isConnected) {
                await deleteStorageTodo(id);
                const storageTodos = await getStorageTodos();
                setTodos(storageTodos);
            } else {
                const removeArr = [...todos].filter(todo => todo._id !== id);

                setTodos(removeArr);
            }
        } catch(e) {
            console.log(e);
        }
    };

    const completeTodo = async id => {
        try {
            if (isConnected) {
                await completeStorageTodo(id);
                const storageTodos = await getStorageTodos();
                setTodos(storageTodos);
            } else {
                const updatedTodos = todos.map(todo => {
                    if (todo.id === id) {
                        todo.isComplete = !todo.isComplete;
                    }
                    return todo;
                });
                setTodos(updatedTodos);
            }
        } catch(e) {
            console.log(e);
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
