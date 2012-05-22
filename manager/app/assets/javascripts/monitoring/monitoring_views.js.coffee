
namespace "Bixby.view.monitoring", (exports, top) ->

  class exports.Layout extends Stark.View
    el: "#content"
    template: "monitoring/layout"


  class exports.MetricList extends Stark.View
    el: "div.monitoring_content"
    template: "monitoring/resource_list"
    events: {
      "click .add_resource_link": (e) ->
        @transition "mon_hosts_resources_new", { host: @host }
      "click div.metric a.metric": (e) ->
        res = @metrics.get $(e.target).attr("resource_id") # FIXME
        metric = $(e.target).attr("metric")
        @transition "mon_hosts_resources_metric", { host: @host, metric: metric }
    }

    render: ->
      super()

      # render graphs into placeholder divs
      @metrics.each (metric) ->
        s = ".check[check_id=" + metric.get("check_id") + "] .metric[metric_id='" + metric.id + "']"
        el = $(s + " .graph")[0]
        data = metric.get("data")

        # draw footer
        footer = $(s + " .footer")
        unit = ""
        if metric.unit?
          if metric.unit != "%"
            unit = " " + metric.unit
          else
            unit = "%"
        footer_text = sprintf("Last Value: %0.2f%s", data[data.length-1].y, unit)
        footer.text(footer_text)

        vals = _.map data, (v) ->
          [ new Date(v.x * 1000), v.y ]

        opts = {
          labels: [ "Date/Time", "v" ]
          strokeWidth: 2
          showLabelsOnHighlight: false
          legend: "never"
        }

        if metric.unit == "%"
          # set range if known
          opts.valueRange = [ 0, 100 ]

        # draw
        g = new Dygraph(el, vals, opts)

        # set callbacks
        xOptView = g.optionsViewForAxis_('x');
        xvf = xOptView('valueFormatter');
        opts = {
          highlightCallback: (e, x, pts, row) ->
            date = xvf(x, xOptView, "", g) + ", " + sprintf("val = %0.2f%s", pts[0].yval, unit)
            footer.text(date)

          unhighlightCallback: (e) ->
            footer.text(footer_text)

          # allow zooming in for more granular data (don't downsample)
          zoomCallback: (minX, maxX, yRanges) ->
            if g.is_granular
              if minX == g.rawData_[0][0] && maxX == g.rawData_[g.rawData_.length-1][0]
                g.updateOptions({ file: g.less_granular })
                g.less_granular = null
                g.is_granular = null
              return

            r = (maxX - minX) / 1000
            if r < 43200
              # load more granular data
              g.less_granular = g.file_
              g.is_granular = true
              new_met = new Bixby.model.Metric({
                id: metric.id
                host_id: metric.get("metadata").host_id
                start: parseInt(minX / 1000)
                end: parseInt(maxX / 1000)
              })
              Backbone.multi_fetch [ new_met ], (err, results) ->
                vals = _.map new_met.get("data"), (v) ->
                  [ new Date(v.x * 1000), v.y ]
                g.updateOptions({ file: vals })

        }
        g.updateOptions(opts);

    render_with_rickshaw: ->
      render()

      # display graphs
      @resources.each (res) ->
        metrics = res.get("metrics");
        _.each metrics, (val, key) ->
          s = ".resource[resource_id=" + res.id + "] .metric[metric='" + key + "']"
          el = $(s + " .graph")[0]

          graph = new Rickshaw.Graph( {
            element: el,
            width: 300,
            height: 100,
            renderer: 'line',
            series: [{
              # name: "foo",
              color: 'steelblue',
              data: val.vals
            }]
          } );
          x_axis = new Rickshaw.Graph.Axis.Time({
            graph: graph,
            # element: $(s + ' .x_axis')[0]
          });
          y_axis = new Rickshaw.Graph.Axis.Y({
            graph: graph,
            orientation: 'left',
            # tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
            element: $(s + ' .y_axis')[0],
          });
          hoverDetail = new Rickshaw.Graph.HoverDetail({
            graph: graph
          });
          graph.render();
          $(s + " .footer").text(sprintf("Last Value: %0.2f", val.vals[val.vals.length-1].y));

  class exports.MetricDetail extends Stark.View
    el: "div.monitoring_content"
    template: "monitoring/metric_detail"
    render: ->
      console.log @
      super()

  class exports.AddCommand extends Stark.View
    el: "div.monitoring_content"
    template: "monitoring/command_add"
    events: {
      "click #submit_check": (e) ->
        # show options for selected commands/checks
        opts = []
        host = @host
        $("input.checkbox:checked").each (idx, el) ->
          opt = new Bixby.model.MonitoringCommandOpts({ id: el.value })
          opt.host = host
          opts.push opt

        if opts.length > 0
          @transition "mon_hosts_resources_new_opts", { host: @host, commands: opts }
    }


  class exports.AddCommandOpts extends Stark.View
    el: "div.command_opts"
    template: "monitoring/command_add_opts"
    events: ->
      view = @
      $("#submit_check").on "click", null, (e) ->
        # create the commands
        checks = []
        _.each view.commands, (cmd) ->
          check = new Bixby.model.Check()
          check.host = cmd.host
          check.set { command_id: cmd.id, host_id: cmd.host.id }

          args = {}
          # gather values
          _.each cmd.get("options"), (opt_hash, opt) ->
            args[opt] = $("##{opt}").val()

          check.set({ args: args })
          checks.push check

        Backbone.multi_save checks, (err, results) ->
          view.transition "mon_view_host", { host: view.host }

      {} # return empty event hash
