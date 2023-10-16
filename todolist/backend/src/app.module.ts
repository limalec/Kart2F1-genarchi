import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { TasksModule } from './tasks/tasks.module.js';

@Module({
  imports: [MongooseModule.forRoot('mongodb://127.0.0.1:27017/'), TasksModule],
})
export class AppModule {}
