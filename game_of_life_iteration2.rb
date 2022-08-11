# frozen_string_literal: true

class Grid
  attr_accessor :grid_height, :grid_width, :grid, :number_generation

  def initialize(grid_height, grid_width)
    @number_generation = 1
    @grid_height = grid_height
    @grid_width = grid_width
    make_grid
  end

  attr_reader :grid

  def print_grid
    puts "Generation #{@number_generation}:"
    @grid_height.times do |i|
      @grid_width.times do |j|
        if @grid[i][j].alive === 0
          print '.'
        else
          print '*'
        end
      end
      puts ''
    end
    puts ' '
  end

  def make_grid
    array = Array.new(@grid_height) { Array.new(@grid_width) { Cell.new } }
    @grid_height.times do |i|
      @grid_width.times do |j|
        array[i][j].pos_x = j
        array[i][j].pos_y = i
        rand(1..100).between?(60, 100) ? array[i][j].revive_cell : array[i][j].kill_cell
      end
    end
    @grid = array
  end

  def update_grid
    @number_generation += 1
    @grid.each do |row|
      row.each do |cell|
        cell.alive = cell.next_state
      end
    end
  end
end

class Game_rules
  def initialize
    puts 'indique numero de columnas'
    @column = gets.chomp.to_i
    puts 'indique numero de filas'
    @row = gets.chomp.to_i
    @grid_object = Grid.new(@column, @row)
    @grid = @grid_object.grid
    check_neighbors
    @grid_object.print_grid
    next_iteration
  end

  def check_neighbors
    @grid.each do |row|
      row.each do |cell|
        neighbors = []
        cell_position_y = cell.pos_y
        cell_position_x = cell.pos_x
        # NORTH
        neighbors << @grid[cell_position_y - 1][cell_position_x] if cell_position_y - 1 >= 0
        # NORTH-EAST
        if cell_position_y - 1 >= 0 && cell_position_x + 1 < @row
          neighbors << @grid[cell_position_y - 1][cell_position_x + 1]
        end
        # EAST
        neighbors << @grid[cell_position_y][cell_position_x + 1] if cell_position_x + 1 < @row
        # SOUTH-EAST
        if cell_position_y + 1 < @column && cell_position_x + 1 < @row
          neighbors << @grid[cell_position_y + 1][cell_position_x + 1]
        end
        # SOUTH
        neighbors << @grid[cell_position_y + 1][cell_position_x] if cell_position_y + 1 < @column
        # SOUTH-WEST
        if cell_position_y + 1 < @column && (cell_position_x - 1) >= 0
          neighbors << @grid[cell_position_y + 1][cell_position_x - 1]
        end
        # WEST
        neighbors << @grid[cell_position_y][cell_position_x - 1] if cell_position_x - 1 >= 0
        # NORTH-WEST
        if (cell_position_y - 1) >= 0 && (cell_position_x - 1) >= 0
          neighbors << @grid[cell_position_y - 1][cell_position_x - 1]
        end

        cell.neighbors = neighbors
      end
    end
  end

  def next_state
    @grid.each do |row|
      row.each do |cell|
        alive = 0
        cell.neighbors.each do |neighbor|
          alive += 1 if neighbor.alive == 1
        end
        if cell.alive == 1
          cell.next_state = if alive < 2
                              0
                            elsif alive > 3
                              0
                            else
                              1
                            end
        elsif alive == 3
          cell.next_state = 1
        end
      end
    end
  end

  def next_iteration
    next_state
    @grid_object.update_grid
    @grid_object.print_grid
  end
end

class Cell
  attr_accessor :alive, :pos_x, :pos_y, :neighbors, :next_state

  def initialize
    @alive = 0
    @pos_x = 0
    @pos_y = 0
    @neighbors = []
    @next_state = 0
  end

  def kill_cell
    @alive = 0
  end

  def revive_cell
    @alive = 1
  end
end

Game_rules.new
