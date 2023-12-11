import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { TasksModule } from './tasks/tasks.module.js';
import { AliveGateway } from './alive/alive.gateaway.js';

@Module({
  imports: [MongooseModule.forRoot('mongodb://localhost:27017/todolist?replicaSet=rs0&appName=todolist'), TasksModule, AliveGateway],
})
export class AppModule {}
