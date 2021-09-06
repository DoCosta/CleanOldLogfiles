# CleanOldLogfiles
This Script Deletes Old Logfiles.


To include Paths to the Logfile cleaner you will habe to create a xml file.
In the File you'll need to use following pattern:

true and false is the boolean for "delete sub-directories"

<config>
	<path>
		<directory>C:\Users\test</directory>
		<deleteSubDirectories>True</deleteSubDirectories>
		<maxAgeOfFile>230</maxAgeOfFile>
	</path>
	<path>
		<directory>C:\Users\test\Downloads</directory>
		<deleteSubDirectories>True</deleteSubDirectories>
		<maxAgeOfFile>10</maxAgeOfFile>
	</path>
	<path>
		<directory>C:\Users\test\daasds</directory>
		<deleteSubDirectories>True</deleteSubDirectories>
		<maxAgeOfFile>10</maxAgeOfFile>
	</path>
</config>
