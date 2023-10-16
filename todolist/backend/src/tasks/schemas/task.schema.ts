import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type TaskDocument = HydratedDocument<Task>;

@Schema()
export class Task {
  @Prop({ required: true, unique: true, index: true, type: Number })
  id: number;

  @Prop({ required: true, type: String})
  description: string;

  @Prop({ required: true, default: false })
  isComplete: boolean;
}

export const TaskSchema = SchemaFactory.createForClass(Task);
