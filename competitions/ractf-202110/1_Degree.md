## 1 - Degree

Category: Misc (OSINT)
Points: 100
Description:

>I love Woody Allen and Bruce Lee, but I could never really find the degrees between them you know?
>Could you help me ? I would also like to know the actor's last name and the movie that connects them.
>Flag format: `DO{numberOfDegrees_FirstName_LastName_Movie_Name}` `Example
> Flag:DO{8_Dwayne_Johnson_Jungle_Cruise}` Note: If the movie name has a subtitle ignore it.

---
As a bit of a film buff I was aware of the term "six degrees of separation" A quick review on Google refreshes my mind.

![](images/20211011065411.png)

This then leads me to the website that will check the two actors.

![](20211011065524.png)

Entering the two names gives me the required link.

![](images/20211011065718.png)

Taking this information:
- Number of Degrees: 2
- FirstName: Jackie
- LastName: Chan
- Movie_Name: Final Cut 
 
And adding it to the flag format, gives us the final answer.

FLAG:
DO{2_Jackie_Chan_Final_Cut}
