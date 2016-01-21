def move(snake, direction)
  (new_snake = grow(snake, direction)).shift
  new_snake
end

def grow(snake, direction)
  new_snake = []
  snake.map { |item| new_snake << item }
  new_snake << [snake.last[0] + direction[0], snake.last[1] + direction[1]]
end

def new_food(food, snake, dimensions)
  x = 0.upto(dimensions[:width] - 1).to_a
  y = 0.upto(dimensions[:height] - 1).to_a
  (possible_food = x.product(y) - food - snake).sample
end

def obstacle_ahead?(snake, direction, dimensions)
  head, obstacle, after = snake.last, false, move(snake, direction).last

  if snake.include?(after) then obstacle = true end
  if after[0] < 0 or after[0] >= dimensions[:width] then obstacle = true end
  if after[1] < 0 or after[1] >= dimensions[:height] then obstacle = true end

  obstacle
end

def danger?(snake, direction, dimensions)
  two_moves = [direction[0] * 2, direction[1] * 2]
  return true if obstacle_ahead?(snake, direction, dimensions)
  return true if obstacle_ahead?(snake, two_moves, dimensions)
  false
end
