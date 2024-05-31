function createChart(data) {

    const width = 640;
    const height = 400;
    const marginTop = 20;
    const marginRight = 0;
    const marginBottom = 30;
    const marginLeft = 40;
    
    const x = d3.scaleBand()
        .domain(data.map(d => d.incidente))
        .range([marginLeft, width - marginRight])
        .padding(0.1);

    const xAxis = d3.axisBottom(x).tickSizeOuter(0);

    const y = d3.scaleLinear()
        .domain([0, d3.max(data, d => d.total)]).nice()
        .range([height - marginBottom, marginTop]);

    const svg = d3.create("svg")
        .attr("viewBox", [0, 0, width, height])
        .attr("style", `max-width: ${width}px; height: auto; font: 10px sans-serif; overflow: visible;`);

    const bar = svg.append("g")
        .attr("fill", "steelblue")
        .selectAll("rect")
        .data(data)
        .join("rect")
        .style("mix-blend-mode", "multiply") 
        .attr("x", d => x(d.incidente))
        .attr("y", d => y(d.total))
        .attr("height", d => y(0) - y(d.total))
        .attr("width", x.bandwidth());

    const gx = svg.append("g")
        .attr("transform", `translate(0,${height - marginBottom})`)
        .call(xAxis)
        .selectAll("text")
        .attr("transform", "rotate(-45)")
        .style("text-anchor", "end");

    const gy = svg.append("g")
        .attr("transform", `translate(${marginLeft},0)`)
        .call(d3.axisLeft(y))
        .call(g => g.select(".domain").remove());

    return Object.assign(svg.node(), {
        update(order) {
            x.domain(data.sort(order).map(d => d.incidente));

            const t = svg.transition()
                .duration(750);

            bar.data(data, d => d.incidente)
                .order()
                .transition(t)
                .delay((d, i) => i * 20)
                .attr("x", d => x(d.incidente));

            gx.transition(t)
                .call(xAxis)
                .selectAll(".tick")
                .delay((d, i) => i * 20);
        }
    });
}

const data = [
    { incidente: "Accidente automovilístico", total: 849 },
    { incidente: "Atropellado", total: 52724 },
    { incidente: "Choque con lesionados", total: 146747 },
    { incidente: "Choque con prensados", total: 936 },
    { incidente: "Choque sin lesionados", total: 231050 },
    { incidente: "Ciclista", total: 6603 },
    { incidente: "Ferroviario", total: 93 },
    { incidente: "Incidente de tránsito", total: 382 },
    { incidente: "Monopatín", total: 204 },
    { incidente: "Motociclista", total: 50294 },
    { incidente: "Otros", total: 263 },
    { incidente: "Persona atrapada / desbarrancada", total: 2718 },
    { incidente: "Persona atropellada", total: 26 },
    { incidente: "Vehiculo desbarrancado", total: 263 },
    { incidente: "Vehículo atrapadovarado", total: 2069 },
    { incidente: "Volcadura", total: 9040 }
];

document.addEventListener("DOMContentLoaded", () => {
    const chart = createChart(data);
    document.getElementById("grafico3").appendChild(chart);
});


function initMap() {
    const map = L.map('grafico2').setView([19.432608, -99.133209], 12); 

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    return map;
}
function getColor(incident) {
    const colors = {
        "Accidente automovilístico": "#ff0000",
        "Atropellado": "#ff7f00",
        "Choque con lesionados": "#ffff00",
        "Choque con prensados": "#7fff00",
        "Choque sin lesionados": "#00ff00",
        "Ciclista": "#00ff7f",
        "Ferroviario": "#00ffff",
        "Incidente de tránsito": "#007fff",
        "Monopatín": "#0000ff",
        "Motociclista": "#7f00ff",
        "Otros": "#ff00ff",
        "Persona atrapada / desbarrancada": "#ff007f",
        "Persona atropellada": "#7f0000",
        "Vehiculo desbarrancado": "#7f3f00",
        "Vehículo atrapadovarado": "#7f7f00",
        "Volcadura": "#3f7f00"
    };
    return colors[incident] || "#000000";
}

function initMap(id) {
    const map = L.map(id).setView([19.432608, -99.133209], 12); 

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    return map;
}

function getColor(incident) {
    const colors = {
        "Accidente automovilístico": "#ff0000",
        "Atropellado": "#ff7f00",
        "Choque con lesionados": "#ffff00",
        "Choque con prensados": "#7fff00",
        "Choque sin lesionados": "#00ff00",
        "Ciclista": "#00ff7f",
        "Ferroviario": "#00ffff",
        "Incidente de tránsito": "#007fff",
        "Monopatín": "#0000ff",
        "Motociclista": "#7f00ff",
        "Otros": "#ff00ff",
        "Persona atrapada / desbarrancada": "#ff007f",
        "Persona atropellada": "#7f0000",
        "Vehiculo desbarrancado": "#7f3f00",
        "Vehículo atrapadovarado": "#7f7f00",
        "Volcadura": "#3f7f00"
    };
    return colors[incident] || "#000000"; 
}

const map1 = initMap('grafico2');

d3.csv('datos_choques_3_meses.csv').then(data => {
    data.forEach(d => {
        const lat = parseFloat(d.latitud);
        const lon = parseFloat(d.longitud);
        const incident = d.incidente_c4;

        L.circleMarker([lat, lon], {
            color: getColor(incident),
            radius: 5
        }).bindPopup(`Incidente: ${incident}`).addTo(map1);
    });

    const legend = L.control({ position: 'bottomright' });

    legend.onAdd = function (map) {
        const div = L.DomUtil.create('div', 'legend');
        const incidents = [
            "Accidente automovilístico", "Atropellado", "Choque con lesionados",
            "Choque con prensados", "Choque sin lesionados", "Ciclista", "Ferroviario",
            "Incidente de tránsito", "Monopatín", "Motociclista", "Otros",
            "Persona atrapada / desbarrancada", "Persona atropellada", "Vehiculo desbarrancado",
            "Vehículo atrapadovarado", "Volcadura"
        ];

        div.innerHTML += '<strong>Incidentes:</strong><br>';
        incidents.forEach(incident => {
            div.innerHTML += `<i style="background: ${getColor(incident)}; width: 18px; height: 18px; float: left; margin-right: 8px;"></i>${incident}<br>`;
        });

        return div;
    };

    legend.addTo(map1);
}).catch(error => {
    console.error('Error loading CSV:', error);
});

const map2 = initMap('grafico4');

d3.csv('datos_fotocivicas.csv').then(data => {
    data.forEach(d => {
        const lat = parseFloat(d.latitud);
        const lon = parseFloat(d.longitud);

        L.circleMarker([lat, lon], {
            color: '#3388ff', 
            radius: 5
        }).bindPopup(`Latitud: ${lat}, Longitud: ${lon}`).addTo(map2);
    });
}).catch(error => {
    console.error('Error loading CSV:', error);
});
