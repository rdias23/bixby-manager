
jQuery ->

  _bv = Bixby.view
  _vn = _bv.monitoring
  _bm = Bixby.model
  Bixby.app.add_state(
    class MonViewHostState extends Stark.State
      name: "mon_view_host" #  canonical name used for state transitions
                            #  e.g., it is referred to in events hash of other states

      url:  "monitoring/hosts/:host_id" #  match() pattern [optional]

      views:      [ _bv.PageLayout, _vn.Layout, _vn.MetricList ]
      no_redraw:  [ _bv.PageLayout, _vn.Layout ]
      models:     { host: _bm.Host, metrics: _bm.MetricList, checks: _bm.CheckList }

      events: {
        mon_hosts_resources_new: { models: [ _bm.Host ] }
        mon_hosts_resources_metric: { models: [ _bm.Host, _bm.Metric ]}
      }

      create_url: ->
        @url.replace /:host_id/, @host.id

      load_data: ->
        needed = []
        if ! @host?
          @host = new _bm.Host({ id: @params.host_id })
          needed.push @host

        if ! @metrics?
          host_id = (@params? && @params.host_id) || @host.id
          @metrics = new _bm.MetricList(host_id)
          needed.push @metrics

        return needed

      activate: ->
        @app.trigger("nav:select_tab", "monitoring")
  )

  Bixby.app.add_state(
    class extends Stark.State

      name: "mon_hosts_resources_metric"
      url:  "monitoring/hosts/:host_id/metric/:metric"

      create_url: ->
        @url.replace(/:host_id/, @host.id).replace(/:metric/, @metric)

      views:      [ _bv.PageLayout, _vn.Layout, _vn.MetricDetail ]
      no_redraw:  [ _bv.PageLayout, _vn.Layout ]
      models:     { host: _bm.Host, resource: _bm.Resource }
  )

  Bixby.app.add_state(
    class extends Stark.State
      name: "mon_hosts_resources_new"
      url:  "monitoring/hosts/:host_id/resources/new"

      views:      [ _bv.PageLayout, _vn.Layout, _vn.AddCommand ]
      no_redraw:  [ _bv.PageLayout, _vn.Layout ]
      models:     { host: _bm.Host, commands: _bm.MonitoringCommandList }

      create_url: ->
        @url.replace /:host_id/, @host.id

      load_data: ->
        needed = []
        if ! @host?
          @host = new _bm.Host({ id: @params.host_id })
          needed.push @host

        if ! @commands
          @commands = new _bm.MonitoringCommandList()
          needed.push @commands

        return needed
  )

  Bixby.app.add_state(
    class extends Stark.State
      name: "mon_hosts_resources_new_opts"
      views:      [ _bv.PageLayout, _vn.Layout, _vn.AddCommand, _vn.AddCommandOpts ]
      no_redraw:  [ _bv.PageLayout, _vn.Layout, _vn.AddCommand ]
      models:     { host: _bm.Host, commands: _bm.MonitoringCommandList }
      load_data: ->
        @spinner = new _bv.Spinner($("div.command_opts"))
        return @commands

      activate: ->
        @spinner.stop()

  )

