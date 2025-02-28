import tkinter as tk
import utils as utils
root=tk.Tk()
root.title("MAC tester")
root.geometry("400x200")
label=tk.Label(root,text="Label1",font=("Arial",16,"bold"))
label.pack(pady=20)

def submit_action():    
    button.bg="#007bff"
    com_port= utils.list_serial_ports()
    #print("Here 1")
    if com_port is None:
        print("Failed to open the FTDI port")
        button.bg="green"
    print(com_port)


button=tk.Button(root,text="click me",font=("Arial",12),bg="#dc3545",command=submit_action)
button.pack(pady=10)

quit_button = tk.Button(
    root,
    text="Quit",
    font=("Arial", 12),
    bg="#dc3545",
    fg="white",
    command=root.quit
)
quit_button.pack(pady=10)

root.mainloop()

#list_serial_ports