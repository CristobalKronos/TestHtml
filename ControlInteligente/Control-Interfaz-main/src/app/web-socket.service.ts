import { Injectable } from '@angular/core';
import { io } from 'socket.io-client';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class WebSocketService {

  socket : any;
  readonly url = "ws://localhost:3000";

  constructor() { 
    this.socket = io(this.url, {
      withCredentials: true,
      autoConnect: true,
      transports: [ 'websocket' ],

    });
  }

  listen(eventName : string){
    return(new Observable( (suscriber) => {
      this.socket.on(eventName, (data: any) => {
        suscriber.next(data);
      });
    }));
  }

  emit(eventName : string, data : any){
    this.socket.emit(eventName,data);
  }
}
