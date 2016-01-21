def move(snake, direction)
  snake.shift
  last_position = snake.last
  new_position = [last_position[0]+direction[0], last_position[1]+direction[1]]
  snake.push(new_position)
end

def grow(snake, direction)
  last_position = snake.last
  new_position = [last_position[0]+direction[0], last_position[1]+direction[1]]
  snake.push(new_position)
end

def new_food(food, snake, dimensions)
  new_food = [rand(dimensions[:width]), rand(dimensions[:height])]
  while food.include?(new_food) or snake.include?(new_food)
    new_food = [rand(dimensions[:width]), rand(dimensions[:height])]
  end
  new_food
end

def obstacle_ahead?(snake, direction, dimensions)
  head = snake.last
  move = [head[0]+direction[0], head[1]+direction[1]]
  obstacle = false

  if snake.include?(move) then obstacle = true end
  if move[0] < 0 or move[0] >= dimensions[:width] then obstacle = true end
  if move[1] < 0 or move[1] >= dimensions[:height] then obstacle = true end

  obstacle
end

def danger?(snake, direction, dimensions)
  two_moves = [direction[0]*2, direction[1]*2]
  return true if obstacle_ahead?(snake, direction, dimensions)
  return true if obstacle_ahead?(snake, two_moves, dimensions)
  false
end
