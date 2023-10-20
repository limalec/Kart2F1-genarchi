import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { TasksModule } from './tasks/tasks.module.js';

@Module({
  imports: [
    MongooseModule.forRoot("mongodb://34.163.103.223:27017,34.155.182.202:27017,34.155.183.101:27017/db-test?replicaSet=rs0"),
    TasksModule,
  ],
})
export class AppModule {}
