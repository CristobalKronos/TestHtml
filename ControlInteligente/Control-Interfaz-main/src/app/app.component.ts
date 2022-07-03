import { Component, OnInit } from '@angular/core';
import { WebSocketService } from './web-socket.service';
import { Chart, ChartConfiguration, ChartItem, registerables } from 'node_modules/chart.js';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'my-first-project';

  tiempo_inicio: number = Date.now();
  chart: any = null;
  listaAux:Array<string> = [];

  textoInput : string = "0";
  texto_aux: string = "0";

  constructor(private WebsocketService: WebSocketService){}

  ngOnInit(){


    this.createChart();

    this.WebsocketService.listen("envio_data").subscribe((dataSerial: any) => {
      
      const tiempo_lectura: number = Date.now();

      const tiempo_intervalo = (tiempo_lectura - this.tiempo_inicio)/1000;

      console.log(dataSerial);

      this.chart.data.labels.push(tiempo_intervalo);

      //this.chart.data.datasets[1].data.push(parseInt(this.textoInput));
      this.chart.data.datasets[1].data.push(parseInt(this.texto_aux));
      this.chart.data.datasets[0].data.push(parseInt(dataSerial.value));
      /*
      if(this.chart.data.datasets[1].data.length > 20){
        this.chart.data.datasets[1].data.shift();
        this.chart.data.datasets[0].data.shift();
      }
      */
      /*
      this.chart.data.datasets.forEach((dataset : any) => {
        dataset.data.push(parseInt(dataSerial.value));
      });
      */

      this.chart.update();
      
      //this.listaAux.push(dataSerial.value);
    });

  }

  createChart(): void {
    Chart.register(...registerables);

    const data = {
    
    labels: [],
      datasets: [{
        label: 'Posición angular en el tiempo',
        backgroundColor: 'rgb(255, 99, 132)',
        borderColor: 'rgb(255, 99, 132)',
        data: [],
      },
      {
        label: 'Setpoint',
        backgroundColor: 'rgb(255, 99, 132)',
        borderColor: 'rgb(0, 0, 0)',
        data: [],
      }
    ]};

    const options = {
      plugins:{
        legend:{

          scales:{
            
            x:{
              title:{
                display: true,
                text: "tiempo (s)"
              }
            },

            y:{
              title:{
                display: true,
                text: "posición angular (°)"
              }
            }

          },

          title:{
            display: true,
            text: "Mi primer grafico"
          }

        }
      }
    }

    const config: ChartConfiguration = {
      type: 'line',
      data: data,
      options: options
    }
    const chartItem: ChartItem = document.getElementById('my-chart') as ChartItem
    this.chart = new Chart(chartItem, config)
  }

  enviarDatos(){

    const aux: number = parseInt(this.textoInput);
    
    if(!isNaN(aux)){ //el input es un numero
      this.texto_aux = this.textoInput;
      this.WebsocketService.emit('envio-setpoint',this.textoInput);
      console.log(parseInt(this.textoInput));
    }
    else{ //el input no es un numero
      console.log("Esto no es un numero");
    }
    
    //this.WebsocketService.emit('envio-setpoint',this.textoInput);
    //console.log(parseInt(this.textoInput));

  }

  download(content:string, fileName:string, contentType:string) {
    const a = document.createElement("a");
    const file = new Blob([content], { type: contentType });
    a.href = URL.createObjectURL(file);
    a.download = fileName;
    a.click();
  }

  onDownload(){
    
    console.log(this.listaAux.toString());

    let aux:string = "";
    
    for(let i = 0; i<this.listaAux.length;i++){

      let replace =  this.listaAux[i].replace('--','_');
      let replace2 =  replace.replace('-','_');
      let split = replace2.split("_");

      let aux2 = aux.concat("{ angulo: " , `${split[0].toString()}, `);
      let aux3 = aux2.concat("PWM: " , `${split[1].toString()} }, `);

      aux = aux3;

    }
    
    const aux4 = aux.substring(1,aux.length-2);
    //const aux5 = aux4.slice(1,-1);
    const dataString = "[{" + aux4.concat("]");

    console.log(dataString);

    //this.download(dataString, "datos_entrenamiento.json", "text/plain");
  }
  
}
