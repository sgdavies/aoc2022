using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace Day07;

public class Directory {
    string Path;
    Nullable<int> size = null;
    public HashSet<Directory> dirs = new HashSet<Directory>();
    public HashSet<int> files = new();

    public Directory(string path) {
        Path = path;
    }

    public int Size() {
        if (!size.HasValue) {
            size = new Nullable<int>(files.Sum() + dirs.Select((dir, _) => dir.Size()).Sum());
        }
        return size.Value;
    }
}
public class Day07 {
    public static void Main(string[] args) {
        Console.WriteLine("Hello, World!");

        var Dirs = new Dictionary<string, Directory>();

        var CurrentPath = "/";
        var CurrentDirectory = new Directory(CurrentPath);
        Dirs.Add(CurrentPath, CurrentDirectory);

        // parse input and populate dirs
        string path = @"./07.txt";
        using (StreamReader sr = File.OpenText(path))
        {
            Directory Dir;
            String DirName = null;
            string s = "";
            while ((s = sr.ReadLine()) != null)
            {
                switch (s) {
                    case string cd when cd.StartsWith("$ cd "):
                        DirName = cd.Split(" ")[2];
                        if (DirName == "..") {
                            CurrentPath = CurrentPath.Substring(0, CurrentPath.LastIndexOf('/'));
                        } else if (DirName == "/") {
                            CurrentPath = "/";
                        } else {
                            CurrentPath += "/" + DirName;
                        }

                        if (!Dirs.ContainsKey(CurrentPath)) {
                            Dir = new Directory(CurrentPath);
                            Dirs.Add(CurrentPath, Dir);
                        }
                        CurrentDirectory = Dirs[CurrentPath];
                        break;

                    case string ls when ls.Equals("$ ls"):
                        // Do nothing - skip to next lines
                        break;

                    case string dir when dir.StartsWith("dir "):
                        DirName = dir.Split(" ")[1];
                        var NewPath = CurrentPath + "/" + DirName;
                        
                        if (!Dirs.ContainsKey(NewPath)) {
                            Dir = new Directory(NewPath);
                            Dirs.Add(NewPath, Dir);
                        } else {
                            Dir = Dirs[NewPath];
                        }
                        CurrentDirectory.dirs.Add(Dir);
                        break;

                    case string file when (!file.StartsWith("$") && file.Split(" ").Length == 2):
                        var size = Int32.Parse(file.Split(" ")[0]);
                        CurrentDirectory.files.Add(size);
                        break;

                    default:
                        Console.WriteLine($"Unexpected line: {s}");
                        break;
                }
            }
        }

        // Console.WriteLine($"Total size: {Dirs["/"].Size()}");
        var sum_under_100_000 = 0;
        var SpaceRequired = 30000000 - (70000000 - Dirs["/"].Size());
        var BestSoFar = Dirs["/"].Size();
        foreach (var Dir in Dirs.Values) {
            var size = Dir.Size();
            if (size < 100000) {
                sum_under_100_000 += size;
            }

            if (size > SpaceRequired && size < BestSoFar) {
                BestSoFar = size;
            }
        }
        Console.WriteLine(sum_under_100_000);
        Console.WriteLine(BestSoFar);
    }
}