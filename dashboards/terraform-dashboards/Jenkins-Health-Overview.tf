resource "signalfx_dashboard" "Jenkins-Health-Overview" {
    name                = "Jenkins-Health-Overview"
    dashboard_group     = signalfx_dashboard_group.jenkins-apm.id
    charts_resolution    = "default"
    time_range = "-24h"

    chart {
      chart_id = signalfx_single_value_chart.FBHnZJSA4AA.id
      column = "6"
      height = "1"
      row = "0"
      width = "2"
    }
    chart {
      chart_id = signalfx_single_value_chart.FBHnQgYA0AI.id
      column = "8"
      height = "1"
      row = "0"
      width = "2"
    }
    chart {
      chart_id = signalfx_single_value_chart.FBHnQQIA0AE.id
      column = "10"
      height = "1"
      row = "0"
      width = "2"
    }
    chart {
      chart_id = signalfx_single_value_chart.FBHnQgYAwAQ.id
      column = "4"
      height = "1"
      row = "0"
      width = "2"
    }
    chart {
      chart_id = signalfx_single_value_chart.FBHuAuMA0AA.id
      column = "0"
      height = "1"
      row = "0"
      width = "2"
    }
    chart {
      chart_id = signalfx_single_value_chart.FBHtz54AwAA.id
      column = "2"
      height = "1"
      row = "0"
      width = "2"
    }
    chart {
      chart_id = signalfx_single_value_chart.FBHncuWA0AE.id
      column = "8"
      height = "1"
      row = "1"
      width = "2"
    }
    chart {
      chart_id = signalfx_time_chart.FBHtToXA0AE.id
      column = "4"
      height = "1"
      row = "1"
      width = "4"
    }
    chart {
      chart_id = signalfx_single_value_chart.FBHuYJdA4AA.id
      column = "0"
      height = "1"
      row = "1"
      width = "2"
    }
    chart {
      chart_id = signalfx_single_value_chart.FBHuIvZA0AA.id
      column = "2"
      height = "1"
      row = "1"
      width = "2"
    }
    chart {
      chart_id = signalfx_time_chart.FBHvQ1JA0AE.id
      column = "10"
      height = "1"
      row = "1"
      width = "2"
    }
    chart {
      chart_id = signalfx_time_chart.FBH3Uh5A0AA.id
      column = "0"
      height = "1"
      row = "2"
      width = "4"
    }
    chart {
      chart_id = signalfx_list_chart.FBH0_MVAwAA.id
      column = "4"
      height = "1"
      row = "2"
      width = "4"
    }
    chart {
      chart_id = signalfx_list_chart.FBH3M7vA0AA.id
      column = "8"
      height = "1"
      row = "2"
      width = "4"
    }

    variable {
      alias = "environment"
      apply_if_exist = "true"
      description = ""
      property = "environment"
      replace_only = "true"
      value_required = "true"
      restricted_suggestions = "false"
      values =  ["*"]
    }
    variable {
      alias = "service.name"
      apply_if_exist = "true"
      description = ""
      property = "service.name"
      replace_only = "true"
      value_required = "true"
      restricted_suggestions = "false"
      values =  ["*"]
    }
}

resource "signalfx_single_value_chart" "FBHnZJSA4AA" {
    name                = "Total Failed Jobs (1d)"
    color_by            = "Dimension"
    is_timestamp_hidden = false
    show_spark_line     = false
    unit_prefix         = "Metric"
    secondary_visualization = "None"

    program_text = <<-EOF
A = data('spans.count', filter=filter('environment', '*') and filter('service.name', '*') and filter('sf_error', 'true')).sum(by=['sf_operation']).sum(over='1d').publish(label='A')
    EOF
}

resource "signalfx_single_value_chart" "FBHnQgYA0AI" {
    name                = "Total Agents"
    color_by            = "Dimension"
    is_timestamp_hidden = false
    show_spark_line     = false
    unit_prefix         = "Metric"
    secondary_visualization = "None"

    program_text = <<-EOF
A = data('jenkins.agents.total', filter=filter('environment', '*') and filter('service.name', '*')).publish(label='A')
    EOF
}

resource "signalfx_single_value_chart" "FBHnQQIA0AE" {
    name                = "Agents Online"
    color_by            = "Dimension"
    is_timestamp_hidden = false
    show_spark_line     = false
    unit_prefix         = "Metric"
    secondary_visualization = "None"

    program_text = <<-EOF
A = data('jenkins.agents.online', filter=filter('environment', '*') and filter('service.name', '*')).publish(label='A')
    EOF
}

resource "signalfx_single_value_chart" "FBHnQgYAwAQ" {
    name                = "Total Jobs (1d)"
    color_by            = "Dimension"
    is_timestamp_hidden = false
    show_spark_line     = false
    unit_prefix         = "Metric"
    secondary_visualization = "None"

    program_text = <<-EOF
A = data('spans.count', filter=filter('environment', '*') and filter('service.name', '*')).sum(by=['sf_operation']).sum(over='1d').publish(label='A')
    EOF
}

resource "signalfx_single_value_chart" "FBHuAuMA0AA" {
    name                = "Build Queue"
    color_by            = "Dimension"
    is_timestamp_hidden = false
    show_spark_line     = false
    unit_prefix         = "Metric"
    secondary_visualization = "None"

    program_text = <<-EOF
A = data('jenkins.queue.waiting', filter=filter('environment', '*') and filter('service.name', '*')).publish(label='A')
    EOF
}

resource "signalfx_single_value_chart" "FBHtz54AwAA" {
    name                = "Builds Blocked"
    color_by            = "Dimension"
    is_timestamp_hidden = false
    show_spark_line     = false
    unit_prefix         = "Metric"
    secondary_visualization = "None"

    program_text = <<-EOF
A = data('jenkins.queue.blocked', filter=filter('environment', '*') and filter('service.name', '*')).publish(label='A')
    EOF
}

resource "signalfx_single_value_chart" "FBHncuWA0AE" {
    name                = "Agents Offline"
    color_by            = "Dimension"
    is_timestamp_hidden = false
    show_spark_line     = false
    unit_prefix         = "Metric"
    secondary_visualization = "None"

    program_text = <<-EOF
A = data('jenkins.agents.offline', filter=filter('environment', '*') and filter('service.name', '*')).publish(label='A')
    EOF
}

resource "signalfx_time_chart" "FBHtToXA0AE" {
    name                = "Successful vs Failed Jobs"
    plot_type           = "ColumnChart"
    unit_prefix         = "Metric"
    color_by            = "Dimension"
  

    viz_options {
      label = "A"
      color = "orange"
    }
    viz_options {
      label = "C"
      color = "navy"
    }

    histogram_options {
      color_theme = "red"
    }

    legend_options_fields {
      enabled         = false
      property        = "status.code"
    }
    legend_options_fields {
      enabled         = true
      property        = "ci.pipeline.id"
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
      enabled         = false
      property        = "jenkins.pipeline.step.name"
    }
    legend_options_fields {
      enabled         = false
      property        = "sf_error"
    }
    legend_options_fields {
      enabled         = true
      property        = "sf_operation"
    }

    show_event_lines    = false

    program_text = <<-EOF
A = data('spans.count', filter=filter('sf_error', 'true') and filter('environment', '*') and filter('service.name', '*')).sum(by=['sf_error', 'sf_operation']).publish(label='A')
C = data('spans.count', filter=filter('sf_error', 'false') and filter('environment', '*') and filter('service.name', '*')).sum(by=['sf_error', 'sf_operation']).publish(label='C')
    EOF
}


resource "signalfx_single_value_chart" "FBHuYJdA4AA" {
    name                = "Builds Running"
    color_by            = "Dimension"
    is_timestamp_hidden = false
    show_spark_line     = false
    unit_prefix         = "Metric"
    secondary_visualization = "None"

    program_text = <<-EOF
A = data('jenkins.queue.buildable', filter=filter('environment', '*') and filter('service.name', '*')).publish(label='A')
    EOF
}

resource "signalfx_single_value_chart" "FBHuIvZA0AA" {
    name                = "Builds Left"
    color_by            = "Dimension"
    is_timestamp_hidden = false
    show_spark_line     = false
    unit_prefix         = "Metric"
    secondary_visualization = "None"

    program_text = <<-EOF
A = data('jenkins.queue.left', filter=filter('environment', '*') and filter('service.name', '*')).publish(label='A')
    EOF
}

resource "signalfx_time_chart" "FBHvQ1JA0AE" {
    name                = "Number of Agents"
    plot_type           = "LineChart"
    unit_prefix         = "Metric"
    color_by            = "Dimension"
  

    viz_options {
      label = "A"
    }

    histogram_options {
      color_theme = "red"
    }


    show_event_lines    = false

    program_text = <<-EOF
A = data('jenkins.agents.total', filter=filter('environment', '*') and filter('service.name', '*')).publish(label='A')
    EOF
}


resource "signalfx_time_chart" "FBH3Uh5A0AA" {
    name                = "Avg Queue Time(ms)"
    plot_type           = "AreaChart"
    unit_prefix         = "Metric"
    color_by            = "Dimension"
  

    viz_options {
      label = "A"
    }

    histogram_options {
      color_theme = "red"
    }

    legend_options_fields {
      enabled         = true
      property        = "attributes.jenkins.pipeline.step.type"
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
      enabled         = true
      property        = "jenkins.url"
    }
    legend_options_fields {
      enabled         = true
      property        = "os.type"
    }
    legend_options_fields {
      enabled         = true
      property        = "gcp_id"
    }
    legend_options_fields {
      enabled         = true
      property        = "host.type"
    }
    legend_options_fields {
      enabled         = true
      property        = "cloud.availability_zone"
    }
    legend_options_fields {
      enabled         = true
      property        = "telemetry.sdk.name"
    }
    legend_options_fields {
      enabled         = true
      property        = "telemetry.sdk.language"
    }
    legend_options_fields {
      enabled         = true
      property        = "host.name"
    }
    legend_options_fields {
      enabled         = true
      property        = "telemetry.sdk.version"
    }
    legend_options_fields {
      enabled         = true
      property        = "cloud.platform"
    }
    legend_options_fields {
      enabled         = true
      property        = "host.id"
    }
    legend_options_fields {
      enabled         = true
      property        = "service.name"
    }
    legend_options_fields {
      enabled         = true
      property        = "service.namespace"
    }
    legend_options_fields {
      enabled         = true
      property        = "cloud.provider"
    }
    legend_options_fields {
      enabled         = true
      property        = "environment"
    }
    legend_options_fields {
      enabled         = true
      property        = "service.version"
    }
    legend_options_fields {
      enabled         = true
      property        = "cloud.account.id"
    }

    show_event_lines    = false

    program_text = <<-EOF
A = data('jenkins.queue.time_spent_millis', filter=filter('environment', '*') and filter('service.name', '*')).publish(label='A')
    EOF
}


resource "signalfx_list_chart" "FBH0_MVAwAA" {
    name                = "Top Executed Steps (1h)"
    color_by            = "Dimension"
    unit_prefix         = "Metric"
    secondary_visualization = "Sparkline"

    legend_options_fields {
      enabled         = true
      property        = "attributes.jenkins.pipeline.step.type"
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
      enabled         = true
      property        = "service.name"
    }

    legend_options_fields {
      enabled         = true
      property        = "jenkins.pipeline.step.name"
    }

    legend_options_fields {
      enabled         = true
      property        = "status.code"
    }

    legend_options_fields {
      enabled         = true
      property        = "span.kind"
    }

    legend_options_fields {
      enabled         = true
      property        = "jenkins.pipeline.step.type"
    }

    legend_options_fields {
      enabled         = true
      property        = "operation"
    }

    legend_options_fields {
      enabled         = true
      property        = "ci.pipeline.id"
    }


    program_text = <<-EOF
B = data('jenkins.calls_total').sum(over='1h').sum(by=['jenkins.pipeline.step.name']).publish(label='B')
A = data('jenkins.calls').sum(over='1h').sum(by=['jenkins.pipeline.step.name']).publish(label='A')
    EOF
}


resource "signalfx_list_chart" "FBH3M7vA0AA" {
    name                = "Top Failed Steps (1h)"
    color_by            = "Dimension"
    unit_prefix         = "Metric"
    secondary_visualization = "Sparkline"

    legend_options_fields {
      enabled         = true
      property        = "attributes.jenkins.pipeline.step.type"
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
      enabled         = true
      property        = "jenkins.pipeline.step.name"
    }


    program_text = <<-EOF
A = data('jenkins.calls', filter=filter('status.code', 'STATUS_CODE_ERROR')).sum(over='1h').sum(by=['jenkins.pipeline.step.name']).top(count=10).publish(label='A')
    EOF
}
