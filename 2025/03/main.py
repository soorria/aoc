with open("input") as file:
    input_text = file.read()

lines = input_text.splitlines()

num_to_join = 12
joltages = []


def to_int(num):
    return int("".join(str(n) for n in num))


for line in lines:
    numbers = [int(c) for c in line]

    curr_max = numbers[-num_to_join:]

    indexes = list(reversed(range(len(line) - num_to_join)))

    for i in indexes:
        n = numbers[i]

        max_num = curr_max
        new_num = [n] + curr_max
        for j in range(num_to_join + 1):
            first_part = new_num[0:j]
            last_part = new_num[j + 1 :]
            combined = first_part + last_part

            if to_int(combined) > to_int(max_num):
                max_num = combined

        curr_max = max_num

    joltages.append(to_int(curr_max))

print(list(enumerate(joltages)))

print(sum(joltages))
