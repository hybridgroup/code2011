function show_chart(json) {
  var r = 960,
      format = d3.format(",d"),
      fill = d3.scale.ordinal().range(["#FFAD63", "#E65200", "#114522", "#9E99C8", "#5B9EC6", "#7E4617", "#024261", "#BD6C2D", "#658960", "#03608C", "#7B7B7B", "#5A5772", "#5E5E5E", "#9DCAE2"]);

  var bubble = d3.layout.pack()
      .sort(null)
      .size([r, r])
      .padding(1.5);

  var vis = d3.select("#chart").append("svg")
      .attr("width", r)
      .attr("height", r)
      .attr("class", "bubble");

  var div = d3.select("#chart").append("div")
      .attr("class", "tooltip")
      .style("opacity", 0);


  var node = vis.selectAll("g.node")
      .data(bubble.nodes(classes(json))
      .filter(function(d) { return !d.children; }))
      .enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
      .on("mouseover", function(d) {
        div.transition()
          .duration(200)
          .style("opacity", .9);
        div.html( d.className + ": " + format(d.value)  )
          .style("left", (d3.event.pageX) + "px")
          .style("top", (d3.event.pageY - 28) + "px");
      })
      .on("mouseout", function(d) {
        div.transition()
          .duration(500)
          .style("opacity", 0);
      })
      .on("click", function(d) {
        window.open('https://twitter.com/search?q=%23code2015%20' + d.className +'&src=typd&f=realtime');
      });
  /*
  node.append("title")
      .text(function(d) { return d.className + ": " + format(d.value); });
  */

  node.append("circle")
      .attr("r", function(d) { return d.r; })
      .style("fill", function(d) { return fill( Math.floor((Math.random()*20)+1) ); });

    node.append("text")
        .attr("text-anchor", "middle")
        .attr("dy", ".3em")
        .text(function(d) { return d.className.substring(0, d.r / 3); });

}
// Returns a flattened hierarchy containing all leaf nodes under the root.
function classes(root) {
  var classes = [];

  function recurse(name, node) {
    if (node.children) node.children.forEach(function(child) { recurse(node.name, child); });
    else classes.push({packageName: name, className: node.name, value: node.size});
  }

  recurse(null, root);
  return {children: classes};
}
