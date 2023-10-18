import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { TasksModule } from './tasks/tasks.module.js';

@Module({
  imports: [MongooseModule.forRoot(process.env.DATABASE_HOST), TasksModule],
})
export class AppModule {}
