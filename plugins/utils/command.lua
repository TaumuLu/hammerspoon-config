function Execute(cmd)
  local output, status = hs.execute(cmd)
  if not status then
    -- hs.alert('execute error')
    Log('execute error'..cmd)
  end
  return Trim(output)
end

function ExecuteBrewCmd(command, params, noExec)
  local execCmd = '/opt/homebrew/bin/'..command..' '
  local cmd = '[ -x '..execCmd..' ] && '..execCmd..(params)
  if noExec then
    return cmd
  end
  return Execute(cmd)
end


function ExecBlueutilCmd(params, noExec)
  return ExecuteBrewCmd('blueutil', params, noExec)
end

function BlueutilIsConnected(callback)
  local isConnected = '0'
  local id = AirPodsId
  isConnected = ExecBlueutilCmd('--is-connected '..id)
  if callback ~= nil then
    callback(isConnected, id)
  end
  return isConnected
end
