using System;
using System.Collections;

public class colas
{
    static public void Main()
    {

        // Create a queue
        // Using Queue class
        Queue my_queue = new Queue();

        // Adding elements in Queue
        // Using Enqueue() method
        my_queue.Enqueue("GFG");
        my_queue.Enqueue(1);
        my_queue.Enqueue(100);
        my_queue.Enqueue(null);
        my_queue.Enqueue(2.4);
        my_queue.Enqueue("Geeks123");

        // Accessing the elements
        // of my_queue Queue
        // Using foreach loop
        foreach (var ele in my_queue)
        {
            Console.WriteLine(ele);
        }
    }
}