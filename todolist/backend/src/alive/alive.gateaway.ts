import {
    MessageBody,
    SubscribeMessage,
    WebSocketGateway,
} from '@nestjs/websockets';

@WebSocketGateway({
    cors: {
        origin: '*',
    },
})
export class AliveGateway {
    @SubscribeMessage('alive')
    handleAlive(@MessageBody() data: string): string {
        return data;
    }
}