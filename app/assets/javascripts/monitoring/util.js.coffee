
Bixby.monitoring = {}

# Render the given metric into the given selector
#
# s: CSS selector root for locating graph, ex:
#
#   s = ".check[check_id=" + metric.get("check_id") + "] .metric[metric_id='" + metric.id + "']"
#
# metric: Metric model instance
Bixby.monitoring.render_metric = (s, metric) ->

  el = $(s + " .graph")[0]

  vals = metric.tuples()
  if !vals || vals.length == 0
    return

  # draw footer
  footer = $(s + " .footer")
  unit = ""
  if metric.unit?
    if metric.unit != "%"
      unit = " " + metric.unit
    else
      unit = "%"
  last_val = vals[vals.length-1][1]
  footer_text = sprintf("Last Value: %0.2f%s", last_val, unit)
  footer.text(footer_text)

  opts = {
    labels: [ "Date/Time", "v" ]
    strokeWidth: 2
    showLabelsOnHighlight: false
    legend: "never"
  }

  gc = $(s + " .graph_container")
  opts.width = gc.width()
  opts.height = gc.height()

  if metric.unit == "%"
    # set range if known
    opts.valueRange = [ 0, 100 ]

  # custom drag interaction - allow toggling pan mode
  opts.interactionModel = _.clone(Dygraph.Interaction.defaultModel)
  opts.interactionModel.mousedown = (event, g, context) ->
    # // Right-click should not initiate a zoom.
    if event.button && event.button == 2
      return

    context.initializeMouseDown(event, g, context)

    if event.altKey || event.shiftKey || g._bixby_mode == "pan"
      Dygraph.startPan(event, g, context)
    else
      Dygraph.startZoom(event, g, context)

  # draw
  g = new Dygraph(el, vals, opts)
  g._bixby_mode = "zoom"

  # set callbacks
  xOptView = g.optionsViewForAxis_('x')
  xvf = xOptView('valueFormatter')
  opts = {
    highlightCallback: (e, x, pts, row) ->
      date = xvf(x, xOptView, "", g) + ", " + sprintf("val = %0.2f%s", pts[0].yval, unit)
      footer.text(date)

    unhighlightCallback: (e) ->
      footer.text(footer_text)

    # allow zooming in for more granular data (don't downsample)
    zoomCallback: (minX, maxX, yRanges) ->
      return if g._bixby_mode == "pan"

      if g._bixby_is_granular
        if minX == g.rawData_[0][0] && maxX == g.rawData_[g.rawData_.length-1][0]
          g.updateOptions({ file: g._bixby_less_granular })
          g._bixby_less_granular = null
          g._bixby_is_granular = null
        return

      r = (maxX - minX) / 1000
      if r < 43200
        # load more granular data
        g._bixby_less_granular = g.file_
        g._bixby_is_granular = true
        new_met = new Bixby.model.Metric({
          id: metric.id
          host_id: metric.get("metadata").host_id
          start: parseInt(minX / 1000)
          end: parseInt(maxX / 1000)
          downsample: "1m-avg"
        })
        Backbone.multi_fetch [ new_met ], (err, results) ->
          g.updateOptions({ file: new_met.tuples() })

  }
  g.updateOptions(opts)
  return g


# just for reference, rendering using rickshaw
# Bixby.monitoring.render_with_rickshaw = (s, metric) ->

#   # display graphs
#   @resources.each (res) ->
#     metrics = res.get("metrics");
#     _.each metrics, (val, key) ->
#       s = ".resource[resource_id=" + res.id + "] .metric[metric='" + key + "']"
#       el = $(s + " .graph")[0]

#       graph = new Rickshaw.Graph( {
#         element: el,
#         width: 300,
#         height: 100,
#         renderer: 'line',
#         series: [{
#           # name: "foo",
#           color: 'steelblue',
#           data: val.vals
#         }]
#       } );
#       x_axis = new Rickshaw.Graph.Axis.Time({
#         graph: graph,
#         # element: $(s + ' .x_axis')[0]
#       });
#       y_axis = new Rickshaw.Graph.Axis.Y({
#         graph: graph,
#         orientation: 'left',
#         # tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
#         element: $(s + ' .y_axis')[0],
#       });
#       hoverDetail = new Rickshaw.Graph.HoverDetail({
#         graph: graph
#       });
#       graph.render();
#       $(s + " .footer").text(sprintf("Last Value: %0.2f", val.vals[val.vals.length-1].y))



