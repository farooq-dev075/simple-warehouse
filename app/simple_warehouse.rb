require 'pry'
require 'pp'

class SimpleWarehouse

  def run
    @live = true
    puts 'Type `help` for instructions on usage'
    while @live
      print '> '
      command = gets.chomp.split(' ')
      case command.shift
        when 'help'
          show_help_message
        when 'init'
          w = command.shift.to_i
          h = command.shift.to_i
          init_grid(w, h)
          pp @grid
        when 'store'
          x = command.shift.to_i
          y = command.shift.to_i
          w = command.shift.to_i
          h = command.shift.to_i
          code = command.shift
          store(x, y, w, h, code)
        when 'view'
          view
        when 'locate'
          code = command.shift
          puts code
          locate(code)
        when 'remove'
          x = command.shift.to_i
          y = command.shift.to_i
          remove(x,y)
        when 'exit'
          exit
        else
          show_unrecognized_message
      end
    end
  end

  private

  def show_help_message
    puts <<~HELP
      help             Shows this help message
      init W H         (Re)Initialises the application as an empty W x H warehouse.
      store X Y W H P  Stores a crate of product code P and of size W x H at position (X,Y).
      locate P         Show a list of all locations occupied by product code P.
      remove X Y       Remove the entire crate occupying the location (X,Y).
      view             Output a visual representation of the current state of the grid.
      exit             Exits the application.
    HELP
  end

  def show_unrecognized_message
    puts 'Command not found. Type `help` for instructions on usage'
  end

  def exit
    puts 'Thank you for using simple_warehouse!'
    @live = false
  end

  def init_grid(w, h)
    @grid = Array.new(h) { Array.new(w) { nil } }
  end

  def view
    pp @grid
  end

  def store(x, y, w, h, code)
    unless @grid.reverse[y-1][x-1].nil?
      puts "Start Position Already Occupied"
      return
    end

    crate_fit = true

    for i in (y-1)..h+(y-2)
      for j in (x-1)..w+(x-2)
        crate_fit = false unless @grid.reverse[i][j].nil?
        unless crate_fit
          puts "Crate doesn't fit"
          return
        end
      end
    end


    for i in (y-1)..h+(y-2)
      for j in (x-1)..w+(x-2)
        @grid.reverse[i][j] = code
      end
    end
  end

  def remove(x,y)
    x= x-1
    y= y-1
    j = x
    code = @grid.reverse[y][j]
    while @grid.reverse[y][j] == code
      while @grid.reverse[y][j] == code
        @grid.reverse[y][j] = nil
        j = j.next
      end
      j = x
      y = y.next
    end
  end

  def locate(code)
    @grid.reverse.each_with_index do |element, outer_index|
      element.each_with_index do |x_code, inner_index|
        puts "(#{outer_index.next},#{inner_index.next})" if x_code == code
      end
    end
  end

end
