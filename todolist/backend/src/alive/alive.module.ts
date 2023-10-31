import { Module } from '@nestjs/common';
import { AliveGateway } from './alive.gateaway';

@Module({
    providers: [AliveGateway]
})
export class AliveModule {}