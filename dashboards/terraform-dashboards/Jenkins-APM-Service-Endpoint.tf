resource "signalfx_dashboard" "Jenkins-APM-Service-Endpoint" {
    name                = "Jenkins-APM-Service-Endpoints"
    description         = "Service-level indicators from APM Tracing Metrics"
    dashboard_group     = signalfx_dashboard_group.jenkins-apm.id
    charts_resolution    = "default"
    time_range = "-24h"

    chart {
      chart_id = signalfx_list_chart.F1Ugj3-AwAQ.id
      column = "0"
      height = "1"
      row = "0"
      width = "6"
    }
    chart {
      chart_id = signalfx_time_chart.F1Ugj3-AwAE.id
      column = "6"
      height = "1"
      row = "0"
      width = "6"
    }
    chart {
      chart_id = signalfx_list_chart.F1Ugj3-AwAI.id
      column = "0"
      height = "1"
      row = "1"
      width = "6"
    }
    chart {
      chart_id = signalfx_time_chart.F1UbZxwA4AA.id
      column = "6"
      height = "1"
      row = "1"
      width = "6"
    }
    chart {
      chart_id = signalfx_time_chart.F1Ugj3-AwAA.id
      column = "0"
      height = "1"
      row = "2"
      width = "6"
    }
    chart {
      chart_id = signalfx_list_chart.F1Ugj3-AwAU.id
      column = "6"
      height = "1"
      row = "2"
      width = "6"
    }
    chart {
      chart_id = signalfx_list_chart.F1Ugj3-AwAM.id
      column = "0"
      height = "1"
      row = "3"
      width = "6"
    }
    chart {
      chart_id = signalfx_list_chart.F1Ugj3-AwAY.id
      column = "6"
      height = "1"
      row = "3"
      width = "6"
    }

    variable {
      alias = "Environment"
      apply_if_exist = "false"
      description = "APM Environment Name"
      property = "sf_environment"
      replace_only = "false"
      value_required = "true"
      restricted_suggestions = "false"
      values =  ["*"]
    }
    variable {
      alias = "Service"
      apply_if_exist = "false"
      description = "APM Service Name"
      property = "sf_service"
      replace_only = "true"
      value_required = "true"
      restricted_suggestions = "false"
      values =  ["*"]
    }
    variable {
      alias = "Pipeline"
      apply_if_exist = "false"
      description = ""
      property = "sf_operation"
      replace_only = "true"
      value_required = "false"
      restricted_suggestions = "false"
      values =  ["*"]
    }
}

## ChartID: signalfx_list_chart.F1Ugj3-AwAQ.id
resource "signalfx_list_chart" "F1Ugj3-AwAQ" {
    name                = "Pipeline Summary (1d)"
    color_by            = "Metric"
    max_precision       = 4

    unit_prefix         = "Metric"
    secondary_visualization = "Sparkline"

    viz_options {
      label = "Error Rate"
      display_name = "Error Rate"
      value_suffix = "%"
    }

    viz_options {
      label = "Jobs Failed"
      display_name = "Jobs Failed"
    }

    viz_options {
      label = "Jobs Total"
      display_name = "Jobs Total"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_originatingMetric"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_metric"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_environment"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_error"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_service"
    }


    program_text = <<-EOF
A = data('spans.count', filter=filter('sf_environment', '*') and filter('sf_service', '*'), rollup='sum').sum(by=['sf_service']).sum(over='1d').publish(label='Jobs Total')
B = data('spans.count', filter=filter('sf_environment', '*') and filter('sf_service', '*') and filter('sf_error', 'true'), rollup='sum').sum(by=['sf_service']).sum(over='1d').publish(label='Jobs Failed')
C = (100*(B/A)).mean(over='1d').publish(label='Error Rate')
    EOF
}

## ChartID: signalfx_time_chart.F1Ugj3-AwAE.id
resource "signalfx_time_chart" "F1Ugj3-AwAE" {
    name                = "Pipeline Length"
    description         = "Pipeline Length"
    plot_type           = "LineChart"
    unit_prefix         = "Metric"
    color_by            = "Dimension"
    minimum_resolution  = 10000
    disable_sampling    = true
  

    viz_options {
      label = "p90"
      value_unit = "Nanosecond"
    }

    histogram_options {
      color_theme = "red"
    }


    show_event_lines    = true
    show_data_markers = true

    program_text = <<-EOF
def weighted_duration(base, p, filter_, groupby):
    error_durations     = data(base + '.duration.ns.' + p, filter=filter_ and filter('sf_error', 'true'),  rollup='max').mean(by=groupby, allow_missing=['sf_httpMethod'])
    non_error_durations = data(base + '.duration.ns.' + p, filter=filter_ and filter('sf_error', 'false'), rollup='max').mean(by=groupby, allow_missing=['sf_httpMethod'])

    error_counts     = data(base + '.count', filter=filter_ and filter('sf_error', 'true'),  rollup='sum').sum(by=groupby, allow_missing=['sf_httpMethod'])
    non_error_counts = data(base + '.count', filter=filter_ and filter('sf_error', 'false'), rollup='sum').sum(by=groupby, allow_missing=['sf_httpMethod'])

    error_weight     = (error_durations * error_counts).sum(over='1m')
    non_error_weight = (non_error_durations * non_error_counts).sum(over='1m')

    total_weight = combine((error_weight if error_weight is not None else 0) + (non_error_weight if non_error_weight is not None else 0))
    total = combine((error_counts if error_counts is not None else 0) + (non_error_counts if non_error_counts is not None else 0)).sum(over='1m')
    return (total_weight / total)

filter_ = filter('sf_environment', '*') and filter('sf_service', '*') and filter('sf_operation', '*') and filter('sf_kind', 'SERVER', 'CONSUMER') and (not filter('sf_dimensionalized', '*')) and (not filter('sf_serviceMesh', '*'))
groupby = ['sf_service', 'sf_environment', 'sf_operation', 'sf_httpMethod']
weighted_duration('spans', 'p90', filter_, groupby).publish(label='p90')
    EOF
}

## ChartID: signalfx_list_chart.F1Ugj3-AwAI.id
resource "signalfx_list_chart" "F1Ugj3-AwAI" {
    name                = "Pipeline Summary By Environment (1d)"
    color_by            = "Dimension"
    max_precision       = 4
    disable_sampling    = true

    unit_prefix         = "Metric"
    secondary_visualization = "Sparkline"

    viz_options {
      label = "Error Rate"
      display_name = "Error Rate"
      value_suffix = "%"
    }

    viz_options {
      label = "Runs Failed"
      display_name = "Runs Failed"
    }

    viz_options {
      label = "Runs Total"
      display_name = "Runs Total"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_originatingMetric"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_environment"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_operation"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_service"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_metric"
    }


    program_text = <<-EOF
filter_ = filter('sf_environment', '*') and filter('sf_service', '*') and filter('sf_operation', '*') and filter('sf_kind', 'SERVER', 'CONSUMER') and (not filter('sf_dimensionalized', '*')) and (not filter('sf_serviceMesh', '*'))
filter_errors = filter('sf_environment', '*') and filter('sf_service', '*') and filter('sf_operation', '*') and filter('sf_error', 'true') and filter('sf_kind', 'SERVER', 'CONSUMER') and (not filter('sf_dimensionalized', '*')) and (not filter('sf_serviceMesh', '*'))
A = data('spans.count', filter=filter_, extrapolation='null').sum(over='1d').sum(by=['sf_environment']).publish(label='Runs Total')
B = data('spans.count', filter=filter_errors, extrapolation='null').sum(over='1d').sum(by=['sf_environment']).publish(label='Runs Failed')
C = (100*(B/A)).sum(by=['sf_environment']).publish(label='Error Rate')
    EOF
}

## ChartID: signalfx_time_chart.F1UbZxwA4AA.id
resource "signalfx_time_chart" "F1UbZxwA4AA" {
    name                = "Failure Rate (%) by Pipeline"
    description         = "Failure Rate (%) by Pipeline"
    plot_type           = "LineChart"
    unit_prefix         = "Metric"
    color_by            = "Dimension"
    minimum_resolution  = 10000
    disable_sampling    = true
  

    viz_options {
      label = "A"
    }
    viz_options {
      label = "B"
    }
    viz_options {
      label = "C"
      value_suffix = "%"
    }

    histogram_options {
      color_theme = "red"
    }


    show_event_lines    = false

    program_text = <<-EOF
filter_ = filter('sf_environment', '*') and filter('sf_service', '*') and filter('sf_kind', 'SERVER', 'CONSUMER') and (not filter('sf_dimensionalized', '*')) and (not filter('sf_serviceMesh', '*'))
A = data('spans.count', filter=filter_ and filter('sf_error', 'true'), rollup='rate').sum(by=['sf_environment', 'sf_service', 'sf_operation', 'sf_httpMethod'], allow_missing=['sf_httpMethod']).publish(label='A', enable=False)
B = data('spans.count', filter=filter_, rollup='rate').sum(by=['sf_environment', 'sf_service', 'sf_operation', 'sf_httpMethod'], allow_missing=['sf_httpMethod']).publish(label='B', enable=False)
C = combine(100*((A if A is not None else 0)/B)).publish(label='C')
    EOF
}

## ChartID: signalfx_time_chart.F1Ugj3-AwAA.id
resource "signalfx_time_chart" "F1Ugj3-AwAA" {
    name                = "Error Rate Summary"
    description         = "Total error rate for all jobs"
    plot_type           = "LineChart"
    unit_prefix         = "Metric"
    color_by            = "Dimension"
    minimum_resolution  = 10000
  

    viz_options {
      label = "A"
    }
    viz_options {
      label = "B"
    }
    viz_options {
      label = "C"
      color = "pink"
      value_suffix = "%"
    }

    histogram_options {
      color_theme = "red"
    }


    show_event_lines    = false

    program_text = <<-EOF
filter_ = filter('sf_environment', '*') and filter('sf_service', '*') and (not filter('sf_dimensionalized', '*'))
A = data('service.request.count', filter=filter_ and filter('sf_error', 'true'), rollup='delta').sum(by=['sf_environment', 'sf_service']).publish(label='A', enable=False)
B = data('service.request.count', filter=filter_, rollup='delta').sum(by=['sf_environment', 'sf_service']).publish(label='B', enable=False)
C = combine(100*((A if A is not None else 0) / B)).publish(label='C')
    EOF
}

## ChartID: signalfx_list_chart.F1Ugj3-AwAU.id
resource "signalfx_list_chart" "F1Ugj3-AwAU" {
    name                = "Top Pipelines by error rate (1d)"
    description         = "Most erroneous service endpoints (1 day error rate average)"
    color_by            = "Dimension"

    unit_prefix         = "Metric"
    secondary_visualization = "Sparkline"

    viz_options {
      label = "C"
      value_suffix = "%"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_originatingMetric"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_metric"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_environment"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_operation"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_httpMethod"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_service"
    }


    program_text = <<-EOF
filter_ = filter('sf_environment', '*') and filter('sf_service', '*') and filter('sf_kind', 'SERVER', 'CONSUMER') and (not filter('sf_dimensionalized', '*')) and (not filter('sf_serviceMesh', '*'))
A = data('spans.count', filter=filter_ and filter('sf_error', 'true'), rollup='rate').sum(by=['sf_environment', 'sf_service', 'sf_operation', 'sf_httpMethod'], allow_missing=['sf_httpMethod']).sum(over='1d').publish(label='A', enable=False)
B = data('spans.count', filter=filter_, rollup='rate').sum(by=['sf_environment', 'sf_service', 'sf_operation', 'sf_httpMethod'], allow_missing=['sf_httpMethod']).sum(over='1d').publish(label='B', enable=False)
C = combine(100*((A if A is not None else 0)/B)).mean(over='1m').top(count=10).publish(label='C')
    EOF
}

## ChartID: signalfx_list_chart.F1Ugj3-AwAM.id
resource "signalfx_list_chart" "F1Ugj3-AwAM" {
    name                = "Top pipelines by Jobs (1d)"
    description         = "Top pipelines by number of Jobs"
    color_by            = "Dimension"

    unit_prefix         = "Metric"
    secondary_visualization = "Sparkline"

    legend_options_fields {
      enabled         = false
      property        = "sf_originatingMetric"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_metric"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_environment"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_operation"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_httpMethod"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_service"
    }


    program_text = <<-EOF
filter_ = filter('sf_environment', '*') and filter('sf_service', '*') and filter('sf_operation', '*') and filter('sf_kind', 'SERVER', 'CONSUMER') and (not filter('sf_dimensionalized', '*')) and (not filter('sf_serviceMesh', '*'))
A = data('spans.count', filter=filter_, rollup='sum', extrapolation='last_value').sum(by=['sf_environment', 'sf_service', 'sf_operation', 'sf_httpMethod'], allow_missing=['sf_httpMethod']).sum(over='1d').top(count=10).publish(label='A')
    EOF
}

## ChartID: signalfx_list_chart.F1Ugj3-AwAY.id
resource "signalfx_list_chart" "F1Ugj3-AwAY" {
    name                = "Top pipelines by job length (1d)"
    description         = "Top pipelines by job length"
    color_by            = "Dimension"

    unit_prefix         = "Metric"
    secondary_visualization = "Sparkline"

    viz_options {
      label = "p90"
      value_unit = "Nanosecond"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_originatingMetric"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_metric"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_environment"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_operation"
    }

    legend_options_fields {
      enabled         = false
      property        = "sf_httpMethod"
    }

    legend_options_fields {
      enabled         = true
      property        = "sf_service"
    }


    program_text = <<-EOF
def weighted_duration(base, p, filter_, groupby):
    error_durations     = data(base + '.duration.ns.' + p, filter=filter_ and filter('sf_error', 'true'),  rollup='max').mean(by=groupby, allow_missing=['sf_httpMethod'])
    non_error_durations = data(base + '.duration.ns.' + p, filter=filter_ and filter('sf_error', 'false'), rollup='max').mean(by=groupby, allow_missing=['sf_httpMethod'])

    error_counts     = data(base + '.count', filter=filter_ and filter('sf_error', 'true'),  rollup='sum').sum(by=groupby, allow_missing=['sf_httpMethod'])
    non_error_counts = data(base + '.count', filter=filter_ and filter('sf_error', 'false'), rollup='sum').sum(by=groupby, allow_missing=['sf_httpMethod'])

    error_weight     = (error_durations * error_counts)
    non_error_weight = (non_error_durations * non_error_counts)

    total_weight = combine((error_weight if error_weight is not None else 0) + (non_error_weight if non_error_weight is not None else 0))
    total = combine((error_counts if error_counts is not None else 0) + (non_error_counts if non_error_counts is not None else 0)).sum(over='1h')
    return (total_weight / total)

filter_ = filter('sf_environment', '*') and filter('sf_service', '*') and filter('sf_operation', '*') and filter('sf_kind', 'SERVER', 'CONSUMER') and (not filter('sf_dimensionalized', '*')) and (not filter('sf_serviceMesh', '*'))
groupby = ['sf_service', 'sf_environment', 'sf_operation', 'sf_httpMethod']
weighted_duration('spans', 'p90', filter_, groupby).mean(over='1d').publish(label='p90')
    EOF
}
