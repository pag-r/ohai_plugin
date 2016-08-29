Ohai.plugin(:Service) do
  provides 'service'

  collect_data(:linux) do

    service Mash.new
    service[:service] = Mash.new
    port = Array.new
    all_lines = Array.new
    f = File.open('/etc/services')
    i = 0
    f.each{|line|
      if i > 1
        port_val = line.split('/')[1]
        if port_val != nil
          port << port_val
          all_lines << line
        end
      end
      i += 1
    }
    f.close

    i =+ 0
    ports_list = port.uniq
    ports_list.each{|single_line|
      by_ports = Array.new
      all_lines.each{|line|
        s = single_line.chomp
        service_name = line.split(' ')[0]
        port_type = line.split('/')[1].chomp
        port_number = line.split(' ')[1].split('/')[0]

        if s == port_type
          by_ports[i] = Mash.new(
            :service_name => service_name,
            :port_number => port_number,
            :port_type => port_type
          )
          if i == 10
            i = 0
            break
          end
          i += 1
        end
        if by_ports != nil
          service[:service][s] = by_ports
        end
      }
    }

  end
end
