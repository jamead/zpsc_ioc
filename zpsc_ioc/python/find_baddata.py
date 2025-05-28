# Define the filename
filename = 'ch2_1amp_overnight_5-8-25.txt'  # Replace with your actual file name

# Open the file and process each line
with open(filename, 'r') as file:
    for line in file:
        columns = line.strip().split()
        if len(columns) >= 2:  # Ensure there are at least two columns
            try:
                second_column_value = float(columns[1])
                if second_column_value < 10:
                    print(line.strip())
            except ValueError:
                # If the second column is not a valid number, skip this line
                continue

