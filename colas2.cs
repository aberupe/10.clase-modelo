using System;
using System.Collections;

public class colas2
{
    static public void Main()
    {
Queue marcas = new Queue();
        marcas.Enqueue("Audi");
        marcas.Enqueue("Opel");
        marcas.Enqueue("BMW");


        Console.WriteLine($"La primera marca es {marcas.Peek()}"); //Audi
        Console.WriteLine($"La primera marca (otra vez) es {marcas.Dequeue()}"); //Audi
        Console.WriteLine($"La segunda marca es {marcas.Dequeue()}"); //Opel

        foreach (string marca in marcas)
            Console.WriteLine(marca);
            
    }
}