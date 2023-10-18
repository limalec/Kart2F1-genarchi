import axios from 'axios';

const API_URL = process.env.API_URL; // Remplacez cette URL par l'URL de votre API

const api = axios.create({
    baseURL: API_URL,
});

export const getStorageTodos = async () => {
    const response = await api.get('');
    return response.data;
};

export const createStorageTodo = async (todo) => {
    const response = await api.post('', todo);
    return response.data;
};

export const updateStorageTodo = async (id, todo) => {
    const response = await api.post(`/update/${id}`, todo);
    return response.data;
};

export const deleteStorageTodo = async (id) => {
    const response = await api.post(`/delete/${id}`);
    return response.data;
};

export const completeStorageTodo = async (id) => {
    const response = await api.post(`/complete/${id}`);
    return response.data;
}
