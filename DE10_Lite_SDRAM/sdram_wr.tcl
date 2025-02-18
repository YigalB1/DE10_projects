# Set the project directory (replace with your actual path)
set project_dir "C:\Users\DNLD\Documents\Projects\DE10_projects\DE10_Lite_SDRAM"

# Set the .sof file name (replace with your actual .sof file)
set sof_file "$project_dir/RTL/output_files/your_projSDRAM.sof"



# Set the .mif file path (replace with your actual .mif file)
set mif_file "$project_dir/MIF/try1.mif"

# Open the In-System Memory Content Editor
if {[catch {
    memory_content_editor -device_name "10M50DAF484C6GES" -sof_file $sof_file
} errorMsg]} {
    puts "Error opening Memory Content Editor: $errorMsg"
    return -1
}

# Load the .mif file
if {[catch {
    memory_content_editor -load_memory_data $mif_file
} errorMsg]} {
    puts "Error loading .mif file: $errorMsg"
    memory_content_editor -close
    return -1
}

# Program the device
if {[catch {
    memory_content_editor -program_device
} errorMsg]} {
    puts "Error programming device: $errorMsg"
    memory_content_editor -close
    return -1
}

# Close the Memory Content Editor
memory_content_editor -close

puts "SDRAM initialization complete."

return 0