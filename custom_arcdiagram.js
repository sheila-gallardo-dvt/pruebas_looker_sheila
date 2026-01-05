looker.plugins.visualizations.add({
  id: "custom_arcdiagram",
  label: "Highcharts Arc Diagram",
  options: {
    // Aquí definimos opciones editables por el usuario
    color_range: {
      type: "array",
      label: "Color Range",
      display: "colors",
      default: ["#90C3EC", "#F6854E", "#F4CF41"]
    }
  },

  create: function(element, config) {
    element.innerHTML = '<div id="container" style="width:100%; height:100%;"></div>';
  },

  updateAsync: function(data, element, config, queryResponse, details, done) {
    
    // 1. Definimos las dependencias (Highcharts + Módulos)
    const scripts = [
      'https://code.highcharts.com/highcharts.js',
      'https://code.highcharts.com/modules/sankey.js',      // Dependencia base
      'https://code.highcharts.com/modules/arc-diagram.js', // El módulo objetivo
      'https://code.highcharts.com/modules/accessibility.js'
    ];

    // 2. Función helper para cargar scripts en orden
    const loadScripts = (urls, callback) => {
      if (urls.length === 0) {
        callback();
        return;
      }
      const script = document.createElement('script');
      script.src = urls[0];
      script.onload = () => loadScripts(urls.slice(1), callback);
      document.head.appendChild(script);
    };

    // 3. Ejecutar carga y renderizado
    loadScripts(scripts, () => {
      // Transformación de datos de Looker a formato Highcharts {from, to, weight}
      // NOTA: Esto asume que tienes Dimensión 1 (Origen), Dimensión 2 (Destino), Medida 1 (Peso)
      const seriesData = data.map(row => {
        const keys = Object.keys(row);
        return {
          from: row[keys[0]].value,
          to: row[keys[1]].value,
          weight: row[keys[2]].value
        };
      });

      // Renderizar el gráfico con la configuración que te di antes
      Highcharts.chart('container', {
        chart: { type: 'arcdiagram', backgroundColor: '#121212' },
        title: { text: 'Main train connections', style: { color: '#FFF'} },
        series: [{
          keys: ['from', 'to', 'weight'],
          data: seriesData,
          colorByPoint: true,
          marker: { lineWidth: 1, lineColor: '#121212', fillOpacity: 1 }
        }]
      });
      
      done();
    });
  }
});
