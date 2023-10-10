# Exercises

# Piping

# In a single pipeline for each condition, find all flights that meet the condition:

# 1. Had an arrival delay of two or more hours


# 2. Flew to Houston (IAH or HOU)


# 3. Were operated by United, American, or Delta


# 4. Departed in summer (July, August, and September)


# 5. Arrived more than two hours late, but didn’t leave late


# 6. Were delayed by at least an hour, but made up over 30 minutes in flight

# What are some other interesting ways we could filter the flight data? How would you build the filter conditions for that?


# Please share your ideas with the group!


# Selection

# 1. What happens if you specify the name of the same variable multiple times in a select() call?


# 2. Does the result of running the following code surprise you? How do the select helpers deal with
# upper and lower case by default? How can you change that default?

flights |> select(contains("TIME"))


# 3. Why doesn’t the following work, and what does the error mean?

flights |> 
  select(tailnum) |> 
  arrange(arr_delay)
#> Error in `arrange()`:
#> ℹ In argument: `..1 = arr_delay`.
#> Caused by error:
#> ! object 'arr_delay' not found
 
# Grouping

# 1. Which carrier has the worst average delays?

# 2. Challenge: can you disentangle the effects of bad airports vs. bad carriers?
# Why/why not? (Hint: think about flights |> group_by(carrier, dest) |> summarize(n()))

# Suppose we have the following tiny data frame:
  
  df <- tibble(
    x = 1:5,
    y = c("a", "b", "a", "a", "b"),
    z = c("K", "K", "L", "L", "K")
  )

# 1. Write down what you think the output will look like, then check if you were correct, and describe what group_by() does.

df |>
  group_by(y)

# 2. Write down what you think the output will look like, then check if you were correct, and describe what arrange() does.
# Also comment on how it’s different from the group_by() in part (a)?
  
  df |>
  arrange(y)

# 3. Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does.

df |>
  group_by(y) |>
  summarize(mean_x = mean(x))

# 4. Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does.
# Then, comment on what the message says.

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))

# 5. Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does.
# How is the output different from the one in part (d).

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "drop")

# 6. Write down what you think the outputs will look like, then check if you were correct, and describe what each pipeline does.
# How are the outputs of the two pipelines different?
  
  df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))

df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))
