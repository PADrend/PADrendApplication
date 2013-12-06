Change Log
  2009-11-25   Claudius Jaehn   Initial version
  2012-07-24   Benjamin Eikel   Update because of new plugin structure

What is in this directory?
- All kind of resources (presets, shaders, ...) that are related to PADrend
  (or one of its libraries like MinSG) and neither part of a specific scene nor
  part of a plugin. All files saved here should be used in the project 
  somewhere. Other files should be saved in the "data" directory or, if they
  belong to a plugin, in the directory of the plugin directly.

How are the files organized?
- There are two different types of directories: 
  Type directories (e.g. Shader) contain solitary files of a specific type. If 
  several different files belong together, they can be grouped in a special 
  directory (e.g. Windows, XML).
