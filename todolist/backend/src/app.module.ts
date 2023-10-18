import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { TasksModule } from './tasks/tasks.module.js';

@Module({
  imports: [
    MongooseModule.forRoot(process.env.DATABASE_HOST, {
      pass: 'ZBW5lDSSY1HNz4EP',
      user: 'kart2f1genarchi',
    }),
    TasksModule,
  ],
})
export class AppModule {}
