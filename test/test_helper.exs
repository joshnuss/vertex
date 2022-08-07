{:ok, _pid} = Agent.start_link(fn -> [] end, name: :metric_log)

ExUnit.start()
