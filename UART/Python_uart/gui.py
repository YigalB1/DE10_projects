import tkinter as tk
import utils as utils
root=tk.Tk()
root.title("MAC tester")
root.geometry("400x200")
label=tk.Label(root,text="Label1",font=("Arial",16,"bold"))
#label.pack(pady=20)
label.grid(row=0, column=0, sticky="e")


def detect_port():    
    button.bg="#007bff"
    com_port= utils.list_serial_ports()
    #print("Here 1")
    if com_port is None:
        print("Failed to open the FTDI port")
        return None
    print(com_port)
    return com_port


#button=tk.Button(root,text="Detect port",font=("Arial",12),bg="gray",command=detect_port)
button=tk.Button(root,text="Detect port",font=("Arial",12),bg="gray",command=lambda: detect_port())

button.grid(row=0, column=0)



# Create the Text widget
output_text = tk.Text(root, width=10, height=2,state=tk.DISABLED, wrap=tk.WORD)
#output_text.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)
output_text.grid(row=0, column=4, sticky="e")





quit_button = tk.Button(
    root,
    text="Quit",
    font=("Arial", 12),
    bg="#dc3545",
    fg="white",
    command=root.quit
)
#quit_button.pack(pady=10)
quit_button.grid(row=1, column=0)


root.mainloop()

#list_serial_ports