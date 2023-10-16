import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Task } from './schemas/task.schema';

@Injectable()
export class TasksService {
  constructor(@InjectModel(Task.name) private taskModel: Model<Task>) {}

  async create(description: string): Promise<Task> {
    const createdTask = new this.taskModel({description, id: Math.floor(Math.random() * 100000)});
    return createdTask.save();
  }

  async delete(id: number): Promise<Task> {
    return this.taskModel.findByIdAndDelete(id);
  }

  async update(id: number, description: string): Promise<Task> {
    const task = await this.taskModel.findById(id);
    const updatedTask = Object.assign(task, description);
    return updatedTask.save();
  }

  async complete(id: number): Promise<Task> {
    const task = await this.taskModel.findById(id);
    task.isComplete = true;
    return task.save();
  }

  async findAll(): Promise<Task[]> {
    return this.taskModel.find().exec();
  }
}
