import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { TasksService } from './tasks.service';
import { Task } from './schemas/task.schema';

@Controller()
export class TasksController {
  constructor(private readonly tasksService: TasksService) {}

  @Get()
  getTasks(): Promise<Task[]> {
    return this.tasksService.findAll();
  }

  @Post()
  createTask(@Body() description: string): Promise<Task> {
    return this.tasksService.create(description);
  }

  @Post('delete/:id')
  deleteTask(@Param('id') id: number): Promise<Task> {
    return this.tasksService.delete(id);
  }

  @Post('update/:id')
  updateTask(
    @Param('id') id: number,
    @Body() description: string,
  ): Promise<Task> {
    return this.tasksService.update(id, description);
  }
}
