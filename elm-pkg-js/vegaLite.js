exports.init = async function(app) {
    var vegaJs = document.createElement('script');
    vegaJs.type = 'text/javascript';
    vegaJs.src = "https://cdn.jsdelivr.net/npm/vega@5";
    document.head.appendChild(vegaJs);

    var vegaEmbedJs = document.createElement('script');
    vegaEmbedJs.type = 'text/javascript';
    vegaEmbedJs.src = "https://cdn.jsdelivr.net/npm/vega-embed@6";
    document.head.appendChild(vegaEmbedJs);

    var vegaLiteJs = document.createElement('script');
    vegaLiteJs.type = 'text/javascript';
    vegaLiteJs.src = "https://cdn.jsdelivr.net/npm/vega-lite@5";
    document.head.appendChild(vegaLiteJs);

    // inject place-holder div, used below in port-handling func
    var vizDiv = document.createElement("div");
    const vizDivId = "viz";
    vizDiv.id = vizDivId;
    document.body.appendChild(vizDiv);

    // define ports
    app.ports.vegaLiteElmToJs.subscribe(function(specs) {
        console.log("Port msg received!");
        vegaEmbed(vizDivId, specs, {actions: false}).catch(console.warn);
    });
}
