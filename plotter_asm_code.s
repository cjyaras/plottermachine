# r1 is x-axis counter limit
# r2 is y-axis counter limit
# r3 contains 4-bit signal information in LSBs (x-y axis enable, x-y axis direction)
# r4 is counter limit for signal
# r5 turns system on (begins movement)
# r6 is error register
# r7 stores the current angle
# r8-11 stores the current instruction
# r12 is pointer to beginning of current instruction
# r13 is end of line (11)
# r14 stores the number from the instruction
# r15 stores the current x coordinate
# r16 stores the current y coordinate


# IMPORTANT DMEM ADDRESS OFFSETS
# 1 - DRAWING INSTRUCTIONS
# 1000 - sin table
# 1360 - cos table
# 1720 - x counter limit
# 2080 - y counter limit
# 2440 - 4-bit signal information

# 10 indicates beginning of file, 11 indicates end of file

# NOPs
nop
nop
nop

# TODO : set the above registers to proper initial values (once their positions in dmem are figured out)
addi $r7, $r0, 0 # Initial angle is 0
addi $r5, $r0, 0 # Make sure system turned off at beginning
addi $r12, $r0, 1 # Because beginning of file is at position 0
addi $r13, $r0, 11 # Load end of line (11)

start_read_instruction:

# Read in instruction here (the numbers are true numbers, NOT ascii)
lw $r8,  0($r12) # Instruction type
lw $r9,  1($r12) # Hundreds digit
lw $r10, 2($r12) # Tens digit
lw $r11, 3($r12) # Units digit

# Check not at end of line
bne $r8, $r13, not_done
j end
not_done:

# Compute number (units -> tens -> hundreds)
# Load units digit
add $r14, $r0, $r11

# Get tens digit, multiply by 10 and add it to current number
addi $r22, $r0, 10
mul $r22, $r22, $r10
add $r14, $r14, $r22

# Get hundreds digit, multiply by 100 and add it to current number
addi $r22, $r0, 100
mul $r22, $r22, $r9
add $r14, $r14, $r22

# Determine the current instruction
addi $r22, $r0, 102 # Forward
bne $r8, $r22, not_forward

# The instruction is forward
# First find the correct counter limits for motors
lw $r1, 1720($r7)
lw $r2, 2080($r7)

# Load relevant 4-bit signal for current angle
lw $r3, 2440($r7)

# Now set duration counter based on radius
# Since clock runs at 50 MHz and it takes four clock cycles to increment counter, 
# one second corresponds to 12.5e6 = 12500000
addi $r22, $r0, 1250
mul $r22, $r22, $r14
addi $r4, $r0, 10000
mul $r4, $r4, $r22

# Set counter variable to 0
addi $r20, $r0, 0

# Turn on system
addi $r5, $r0, 1

loop: 
blt $r4, $r20, turn_off_system
addi $r20, $r20, 1
j loop

turn_off_system:
addi $r5, $r0, 0
j after_instruction

not_forward:
addi $r22, $r0, 114 # Right
bne $r8, $r22, not_right

# The instruction is right turn
# Subtract off current number from current angle
sub $r7, $r7, $r14

# If we have underflowed, need to add 360
blt $r7, $r0, underflow
# No underflow
j after_instruction

underflow:
# Underflow from subtraction
addi $r7, $r7, 360
j after_instruction

not_right:
addi $r22, $r0, 108 # Left
bne $r8, $r22, invalid_instruction

# The instruction is left turn
# Add current number to current angle
add $r7, $r7, $r14

# If we have overflowed, need to subtract 360
addi $r21, $r0, 360
blt $r21, $r7, overflow
# No overflow
j after_instruction

overflow:
# Overflow from addition
addi $r7, $r7, -360
j after_instruction

invalid_instruction:
# We have invalid instruction, set flag and abort
addi $r6, $r0, 1
j end

after_instruction:
addi $r12, $r12, 4 # Move to next instruction
j start_read_instruction

end:
# Need to do something (like play noise) if error occured, check error register for flag set
j end