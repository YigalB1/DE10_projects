import tkinter as tk
import utils as utils

com_port = None
baud=115200
ser=None


def my_button(_txt,_row,_col,_func):
    print("@@ in my_button")
    print(_txt)
    print(_row)
    print(_col)
    print(_func)
    my_butt=tk.Button(root,text=_txt, width=20, height=2,font=("Arial",12),bg="gray",command=lambda: _func)
    my_butt.grid(row=_row, column=_col)
    return my_butt


def x_or_v(_row,_col):
    res_label = tk.Label(root, text="", font=("Arial", 30))
    res_label.grid(row=_row, column=_col, pady=0)  # Place in row 0, column 1
    return res_label


def display_result(success):
    if success:
        result_label.config(text="\u2714", fg="green")
    else:
        result_label.config(text="\u274C", fg="red")




def port_button_clicked():
    global com_port
    #print (port_button_state)
    com_port= utils.list_serial_ports()
    print(com_port)
    res_label=x_or_v(0,6)
    if com_port is None:
        #print("Failed to open the FTDI port")
        port_button.config(bg="red")
        res_label.config(text="\u274C", fg="red")
    else:
        # port com assigned OK
        port_button.config(bg="green")
        output_text.insert("1.0", com_port)
        s_port_button.config(state=tk.NORMAL)
        res_label.config(text="\u2714", fg="green")



def serial_button_clicked():
    global ser
    res_label=x_or_v(1,6)
    ser = utils.create_serial_port(com_port, baud)
    print("@ in port_button_clicked")
    print(ser)
    print(com_port)
    check_conn_button.config(state=tk.NORMAL)
    if (ser==None):
        res_label.config(text="\u274C", fg="red")
    else:
        res_label.config(text="\u2714", fg="green")


def check_connection_clicked():
    res_label=x_or_v(2,6)
    val=16
    my_byte = bytes([val])
    utils.send_byte(ser,my_byte)
    ret_val=utils.read_uart(ser)
    if ret_val==None:
        print("faild")
        res_label.config(text="\u274C", fg="red")
    else:
        print("good")
        print(str(ret_val))
        print(ret_val[0])
        test_button.config(state=tk.NORMAL)
        res_label.config(text="\u2714", fg="green")



def test_button_clicked():
    res_label=x_or_v(3,6)
    num_of_tests=1000
    res,good,bad=utils.test_many(ser,num_of_tests)

    out_txt="Num of tests: "+str(num_of_tests)+", passed: "+str(good)+", failed: "+str(bad)
    test_text.insert("1.0", out_txt)
    
    if res=="failed":
        print("faild")
        res_label.config(text="\u274C", fg="red")
    else:
        print("good")
        res_label.config(text="\u2714", fg="green")
    
    
def quit_clicked():
    #global ser
    print("in command=lambda: quit_clicked() ")
    print(ser)
    #ser.close()
    root.quit


    

port_button_state = "normal"
root=tk.Tk()
root.title("MAC tester")
root.geometry("600x400")
label=tk.Label(root,text="Label1",font=("Arial",16,"bold"))
#label.pack(pady=20)
label.grid(row=0, column=0, sticky="e")



result_label = tk.Label(root, text="", font=("Arial", 30))
result_label.grid(row=4, column=3, pady=20)  # Place in row 0, column 1


port_button=tk.Button(root,text="Detect port", width=20, height=2,font=("Arial",12),bg="gray",command=lambda: port_button_clicked())
port_button.grid(row=0, column=0)

# 1March2025: failed to use my_button function - something fails with execution.
# back to full button for each button
#print("here")
#port_button=my_button("Detect port",0,0,port_button_clicked)
#port_button.l

# Create the Text widget
output_text = tk.Text(root, width=10, height=2)
output_text.grid(row=0, column=4, sticky="e")

s_port_button=tk.Button(root,text="Open Serial Port", width=20, height=2,font=("Arial",12),bg="gray",command=lambda: serial_button_clicked())
s_port_button.grid(row=1, column=0)
s_port_button.config(state=tk.DISABLED)

check_conn_button=tk.Button(root,text="Check connection", width=20, height=2,font=("Arial",12),bg="gray",command=lambda: check_connection_clicked())
check_conn_button.grid(row=2, column=0)
check_conn_button.config(state=tk.DISABLED)

test_button=tk.Button(root,text="testX1000", width=20, height=2,font=("Arial",12),bg="gray",command=lambda: test_button_clicked())
test_button.grid(row=3, column=0)
test_button.config(state=tk.DISABLED)

test_text = tk.Text(root, width=50, height=1)
test_text.grid(row=4, column=0, sticky="e")



quit_button = tk.Button(
    root,
    text="Quit",
    font=("Arial", 12),
    bg="#dc3545",
    fg="white",
    command=root.quit
    #command=lambda: quit_clicked()
)
#quit_button.pack(pady=10)
quit_button.grid(row=6, column=0)


root.mainloop()

#list_serial_ports