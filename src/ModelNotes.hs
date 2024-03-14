{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module ModelNotes where

import Data.String.Here (here)

part1 :: Text
part1 = [here|
# Efficient Giving to State Legislative Elections
Democratic donors are more interested than ever in state-legislative races. So
it’s increasingly important to know how to allocate money among those races.

Ideally, knowing as much as possible about the competitiveness
of each seat, especially in states where control of, or a supermajority in, a chamber
is potentially up for grabs,
allows us to focus our efforts on the state legislature races where we can have the
greatest “bang for the buck.”

We think our modeling and data-driven approaches
can contribute to this analysis and help refine slates of state legislature races
for donors to support. In the first part of this post, we’ll explain the basic
idea and give some examples of how we think our approach can be helpful.
In the second part, we’ll dig into the technical details of our model.

### Contents
1. [Why It’s Hard to Analyze State Legislative Races](#s1)
2. [Past Partisan Lean (PPL): The Standard Approach](#s2)
3. [Demographic Partisan Lean (DPL): Our Modeling Approach](#s3)
4. [Examples of insights from DPL for donors and organizers](#s4)
   a. [Comparing PPL and DPL to identify “flippable” and “vulnerable” races](#s4a)
   b. [Testing Various turnout / GOTV scenarios](#s4b)
   c. [Identifying “double word score” opportunities](#s4c)
5. [Conclusion: How Can We Help?](#s5)
6. [Appendix: Technical Details about our model](#a1)

### Why It’s Hard to Analyze State Legislative Races {#s1}

Local expertise in a particular district or set of districts is often
the best way to figure out which races are close-but-winnable.
However, such knowledge is often hard to find and it’s useful to have ways of
looking at state-legislative districts that we can
apply to the state or country as a whole.

Polling would be extremely useful, but polls are expensive and
state-legislative-races don’t usually generate enough news interest
to field a poll. Additionally, there’s less information available about
the demographic characteristics of the people who live in geographic
regions as small as a state-legislative district. This makes the work of
weighting a poll–adjusting the responses you get to
estimate the responses you would’ve gotten from a
representative sample of voters–quite difficult.

That leaves us with various options for using historical data to help Democratic donors
figure out which state legislature candidates to support. The primary strategy
is to use historical results to identify “close” races.
We think our modeling approach–which incorporates data on the recent turnout and
partisan lean of various demographic groups–provides an extra set of helpful
tools for looking at these races.

### Past Partisan Lean (PPL): The Standard Approach {#s2}
The most straightforward way to find close-but-winnable races is to look at what happened
in previous elections, either for the same districts or statewide.
[Dave’s Redistricting](https://davesredistricting.org/maps#home)
does a spectacular job of joining district maps and precinct-level data from previous
elections to create an estimate of the Past-Partisan-Lean[^ppl] (PPL) of every
state-legislative-district in the country. Their rich interface allows the user to choose various
previous elections (or combinations of them) to estimate the partisan lean.

[^ppl]: By “partisan lean” we mean the 2-party vote share of Democratic votes, that
is, given $D$ democratic votes and $R$ Republican votes,
we will report a partisan lean of $\frac{D}{D+R}$, ignoring the third-party votes.

As an example, here is chart of the 2021 PPL in the VA house[^pplVA], the lower
chamber of the VA state-legislature. As with many such maps,
it looks mainly Republican (Red) but that’s because the
Democratic leaning districts are often geographically smaller, in
places like cities, with higher population density. As the 2023 election showed,
there are slightly more D leaning districts in VA than R leaning ones.

In this chart and various charts and tables to follow, we use blue/red shading
to indicate Democratic vs Republican vote share.

[^pplVA]: Using 2020 ACS population estimates and a composite of presidential and statewide
elections from 2016-2021: 2018 and 2020 senate as well as Governor and AG from 2021.
|]
part1b :: Text
part1b = [here|
However, this backward-looking approach doesn’t help us find contests
where focused efforts might shift the outcome toward Democrats or be needed to protect a previously
safe seat.
|]

part2 :: Text
part2 = [here|
PPL alone tells you nothing about *why* a district has the lean it does.
For that you need local knowledge and/or some other sort of analysis.
You can look at the demographic composition of a district and make some inferences
but doing that more systematically, via a detailed demographic model applied to
robust estimates of the demographic composition of each district, provides more
information with greater consistency across districts and states.

Demographic analysis can help identify opportunities and vulnerabilities for Democrats.
District PPLs inconsistent with their location and demographic makeup may
indicate a possibly flippable or safe-looking-but-vulnerable district.
It may also uncover districts that can be downgraded as donation targets because the underlying
demographics make them likely less close than history suggests.

For example, imagine a state-legislative-district with PPL just below some cutoff for winnable.
A demographic analysis shows that its “expected” partisan-lean is over 50%.
Might that be a district where a good and well-resourced candidate can win a race or,
in losing a close race, change the
narrative going forward? Might it be useful to be alerted to a district which looks
easily winnable by PPL standards but with “expected” partisan lean much closer to 50%?
That district might be vulnerable to the right opposition candidate,
especially in a tough political environment.

### Demographic Partisan Lean (DPL): Our Modeling Approach {#s3}
Our model takes a different approach based on Demographic Partisan Lean (DPL).
Rather than considering how people in a specific place have voted in previous elections,
we categorize people demographically, in our case
by state, age, sex, educational-attainment, race/ethnicity, and population-density[^buckets].
Using large surveys of turnout and party-preference
we model expected turnout and party-preference for each of those categories.
Then, given the numbers of people in each of those categories in a district,
we combine them to compute
the (modeled) partisan lean among expected voters. Technical details are at the
end of this post.

One way to think of DPL is as a very detailed analysis of
voting patterns based on race or education or age. Each of those can be a valuable predictor
of turnout and party-preference. But sometimes the *combination* of categories is essential
for understanding. For example, the Republican lean of white non-college-educated voters
is greater than you expect from the Republican lean of white voters and the Republican lean
of non-college-educated voters combined. This gets even more complex and harder to keep track of
once you add age and sex. All of these things may vary from state to state. Population density
affects party-preference quite strongly in ways not well captured by any of those categories.

DPL is the partisan lean of a district if,
within each demographic group, each person’s choice to vote and whom to vote for
was more or less the same as everyone else in the state living at similar population density[^dpl].
This is less
*predictive* than knowing who those same people voted for in the previous few elections. But
it’s different information, and particularly interesting when it’s inconsistent with
the PPL.

[^dpl]: The model takes the state into account but the fit is not separate for each state. We use
something called “partial-pooling”: we allow the fitting
process itself to control how much it uses data from the state and when to “borrow strength”
from the national data. We’d expect the state data to be more predictive but there isn’t that much
of it for each category (since we have 200 categories!). So there’s a tradeoff.

Here’s what this looks like in VA:

[^buckets]: For age we use five categories: 18-24, 25-34, 35-44, 45-64, and 65 and over. For sex we use two: male and female.
Almost none of our source data tracks sex in a more fine-grained way. For educational attainment,
we use four categories: non high-school graduate, high-school graduate, some college, and college-graduate.
And for race/ethnicity we use five categories:
Black, Hispanic, Asian American/Pacific Islander (AAPI), white Non-Hispanic and Other.
With all of these categories there would be value to finer gradations but
that would also create computational and data difficulties. As it is, this setup uses 200 buckets
per state.]
|]


{-
However, a major drawback of PPL is that it doesn’t help much with scenario analysis.
E.g., what would happen in a
given seat if women turned out at higher rates and were more likely to vote
for the democratic candidate? With a demographic
breakdown and model of turnout and partisan lean we can estimate these
sorts of effects.
-}


part3 :: Text
part3 = [here|
## Examples of insights from DPL for donors and organizers {#s4}
### Comparing PPL and DPL to identify “flippable” and “vulnerable” races {#s4a}
The maps of PPL and DPL are, unsurprisingly, similar but there are some large differences which
are clearer on a chart of just the difference (DPL - PPL) below.
|]

part3b :: Text
part3b = [here|
We can see
that there are a few districts which might be interesting to look at. This is clearer
in table form: below we list some districts which are not close in PPL but, when looked at
demographically, *ought* to be close.
These are districts that might be flippable or look like safe seats but need defending.
It’s not that these seats *are* flippable (or in need of extra defense) but that they are
worth a second look. For each district like this, there is a story which explains why it votes how it does
despite the demographic head- or tail-winds. But sometimes that story will suggest an opportunity for the right
candidate or the necessity of bolstering a potentially vulnerable one.
|]

part4 :: Text
part4 = [here|
A quick note: We did this analysis pre-election and all of the contested districts in the list above played
out pretty much as history (PPL) would suggest. This leads to some questions about what we can glean from
the difference between the PPL and DPL in these cases[^hd52].

[^hd52]:For example, House district 52 (Lower-52) was won by the R candidate
54-45. House district 52 is between the median R and D districts in terms of population
density and %voters-of-color and slightly closer to the median R district in terms of the % of white voters
who have graduated from college. So why did our model think this might be a D district? The
median white voter in the district is younger than in the typical district in VA
(moving their modeled preference from 45/55 to 50/50),
and the district has a significant number of black voters (25% of the over-18 population
and 21% of the modeled electorate).
Obviously something about that analysis is wrong! It
would be interesting to know what: Are these younger white voters very R leaning despite their age?
Are Black voters a smaller fraction of the electorate than we thought?
Either or both of those might suggest a path forward for a D candidate in the district.

### Testing Various turnout / GOTV scenarios {#s4b}
Since the DPL is built from an estimate of who lives in a district and how likely each of them is
to turn out and vote for the Democratic candidate, we can use it to answer some
“what would happen if...” sorts of questions. If you imagine some voters are
more energized and thus more likely to vote and/or more likely to vote for the Democratic
candidate, that might change which seats are in play and which are safe. For example,
suppose we think the Dobbs decision overturning Roe v. Wade will raise turnout among women
by 5% and also pushes their party preference 5 points towards Democratic candidates[^scenario].
What would this mean for the 20 closest (by PPL) house districts in VA?

A quick note on the numbers: for the
purposes of these tables, we consider any district which has more than 60% D share to be "safe D", between
55% and 60% share to be lean D, between 55% and 51% to be "tilt D" and between 49% and 51% to be a "tossup"
(and similarly for R tilt/lean/safe). These break points are arbitrary but they help illustrate the general
idea of how one can bucket the various districts.

[^scenario]: A technical note: we don't actually move the probabilities by 5% (or whatever) for a couple of reasons.
We don't want to end up with probabilities above 100% or below 0 which could happen with larger shifts and/or
probabilities already closer to 0 or 1. And, intuitively, very low and very high probabilities are likely to
shift less than probabilities closer to 50%. So we shift using the logistic function in such a way that
for a shift of $x$, we would shift a probability of $\frac{1}{2} - \frac{x}{2}$ to $\frac{1}{2} + \frac{x}{2}$
but smoothly apply slightly smaller shifts as the probability moves away from $\frac{1}{2}$.
|]

part4b :: Text
part4b = [here|
Of course, you don’t need any sort of model to figure out that shifting the
turnout and preference of female voters by 5% would shift the resulting vote share
by a bit more than 2.5%. Women make up slightly more than half the electorate in most
districts so a 5 point preference shift among women will be a slightly more than 2.5 point
shift in vote share, with another slight boost coming from the turnout shift.

But what if you thought the preference shift was only among women with a college degree?
This is a tricker thing to map out in VA. Here’s the same table but with that scenario:
|]

part4c :: Text
part4c = [here|
In this case the shift varies from 0.5 to over 1.5 points, making a smattering of rating changes among
these districts.

This might also be useful when considering a targeted intervention. E.g., how much would you have to
boost turnout among people 18-35 to meaningfully shift the likely vote-share in competitive
districts? Imagine we think we can boost youth turnout by 5% across the state.
How much would that change the final vote-share across the state? It turns out that makes very
little difference in close districts in VA, primarily because the typical under 35 voter in VA is not
overwhelmingly more likely to vote for Democrats. So it makes a small difference and one that
can be positive or negative, depending on the district.
|]

part5 :: Text
part5 = [here|
When doing these analyses, we’ve chosen PPL as our baseline. But one could just as easily use
some other framework or model to come up with a baseline and still use DPL based scenario
analysis to understand how much and where things might change under various circumstances.

### Identifying “double word score” opportunities {#s4c}
Once we have PPL to make allocation recommendations for donors, e.g., give to any race within 5 points of 50/50,
how can we narrow (or broaden) that list? Are we missing any districts worth an investment of resources?
Are we including any that are too hard or too easy to win?
Among all the districts we consider close, are some better “investments” than others?

Sometimes it’s helpful to think about how the district relates to other races on the same
ticket, the so-called “reverse-coattails” effect (“reverse” because we are referring to races
for smaller offices helping a larger race on the same ballot).

When a district overlaps geographically with another important election we call that a
a “double word score.” For instance, in a presidential election year, any close
state-legislative district in a swing state might be a good or appealing place to direct donor dollars.
Close senate races also generate these sorts of opportunities. (As above, this is intended to
be illustrative; one could change the breakpoints to be more selective or permissive
about identifying multi-word-score opportunities.)

Looking at competitive *congressional* districts
gives “double word score” opportunities for some state-legislative-districts
and not others. These are trickier to find than statewide elections: we need to
know the population overlaps of the congressional and state-legislative districts.
As an example, let’s consider the 2024 election in Wisconsin. The chart below
contains all the competitive state-legislative districts (PPL between 45% and 55%) and whichever congressional
district contains most of the state-legislative-district. In green, we’ve highlighted the districts where the
overlapping congressional districts are also competitive by PPL. The WI congressional races are already
triple word scores in ‘24 because WI is a swing state and has a competitive senate race.
The state-legislative-districts highlighted in green in the table below are actually *quadruple* word scores!

This might be a nice frame for driving donor money aimed at the bigger races into the state-legislative races.
|]


part6 :: Text
part6 = [here|
## Conclusion: How Can We Help? {#s5}
We developed these tools in order to help elect more Democrats to state legislative office.
If there are ways we can deploy this data or these tools in order to help you decide where
to send your money or help your donors make those decisions, please let us know! If it’s helpful,
we’re happy to discuss the details, provide custom views into this data and our analysis or be
pointed in helpful directions for further work.

## Appendix: Technical Details about our model {#a1}
We’re going to explain what we do in steps, expanding on each one further down in the document
and putting some of the mathematical details in other, linked documents. Our purpose here
is to present a thorough idea of what we do without spending too much time on any of the
technical details.

Our survey data comes from the Cooperative Election Study ([CES](https://cces.gov.harvard.edu)),
a highly-regarded survey which runs every 2 years and validates
people’s responses about turnout via a third-party which uses voter-file data[^vf]. The
CES survey includes approximately 60,000 people per election cycle. It gathers demographic and
geographic information about each person as well as information about voting and party preference.

[^vf]: CES has used different validation partners in different years. Whoever partners with the
CES in a particular year attempts to match a CES interviewee with a voter-file record in that state
to validate the survey responses about registration and turnout.

The CES data includes the state and congressional district of each person interviewed. We use that
to join the data to population-density data from the 5-year American Community
Survey ([ACS](https://www.census.gov/programs-surveys/acs/microdata.html)) data, using
the sample ending the same year as the CES survey was done.

We then fit a hierarchical multi-level regression of that data, one for
turnout, one for party-preference and one for both jointly.
To compute expected turnout, party-preference of voters or DPL in a district,
we  “post-stratify” the model using the demographics of the district. That
demographic data is also sourced from the ACS, though via a different path
because the microdata is not available at state-legislative-district sized
geographies. We use Hamiltonian Monte Carlo for fitting the model so
the result of post-stratification is a distribution of
turnout, party-preference or DPL, giving us an expectation and various
ways to look at uncertainty.

Let’s dig into the details a bit!

### Choosing Our Sources
Our present model uses the 2020 CES survey as its source and
we choose presidential vote as our
party-preference indicator[^CES2022].

[^CES2022]: We will have the
2022 CES survey as a possible source available to us soon. It’s not clear
which is more appropriate for thinking about 2024. 2022 is more recent and so
might better capture current demographic voting trends,
but 2020 is the most recent *presidential* election year.
If we use 2022, we will
switch to house-candidate vote and include incumbency in the regression model
for party-preference. We’re thinking about ways to combine these but it’s not
straightforward for a variety of reasons. We could also model using both and
have two DPL numbers to look at per district.

The ACS is the best available *public* data for figuring out the demographics
of a district. We get ACS population tables at the census-tract
level and aggregate them to the district level. Unfortunately, none of these
tables alone has all the categories we want for post-stratification.
We use statistical methods[^nsm] to
combine those tables, producing an estimated population table with all of our
demographic categories in each district.

[^nsm]: We will produce another explainer about just this part of the DPL. Basically,
the ACS data is provided in tables which typically cover 3-categories at a time,
for example citizenship, sex and race/ethnicity. To get the table we want,
citizenship x age x sex x education x race/ethnicity–citizenship is there so we
can get the final table for citizens only since only citizens can vote–we need
to “combine” 3 of those tables. We use data from larger geographies and a model
of how those tables fit together based on the data in each of them, to estimate
the correct combination in each district. There is a large and confusing literature
full of techniques for doing this. The one we’ve developed has some advantages
in terms of accuracy and statistical bias and the disadvantage of being somewhat more
complex.

There are various companies that use voter-file data
(which is public but costs money and requires work to standardize) and various other data and
modeling (e.g., using names to predict race and sex) to estimate a population table
for any specific geography. We’ve not had a chance to compare the accuracy of our methods
to theirs but we imagine those methods are capable of being quite accurate as well.

### Modeling the Turnout and Party-Preference
The CES survey provides data for each person interviewed. The demographic data is provided,
along with a weight, designed so that subgroups by age, race, etc. are correctly represented once
weights are accounted for. For example, if you know that there are equal numbers of men and women
(CES has just begun tracking gender categories other than male or female but the ACS does not)
in a congressional district but your survey has twice as many women as men, you would adjust the
weights so that those interviews have equal representation in a weighted sum. Because our demographic
categories are more coarse-grained than what the CES provides (e.g., CES gives age in years but we want
to model with 5 age buckets) we need to aggregate the data. We use the weights when aggregating and this
means that in the aggregated data we have non-whole numbers of voters and voters preferring one party or the other.

We imagine each person in a demographic category and state has a
specific fixed probability of voting and the voters among them a
different probability of voting for the Democratic candidate. This would lead to a binomial model of vote
counts. This is obviously a simplification but a fairly standard one, and a reasonable fit
to the data. As mentioned above, we have non-whole counts. So we use a generalization of the
binomial model[^bg] which allows for this.

[^bg]: Specifically, we use the binomial density but just allow non-integer “successes” and “failures”.
This is not an actual probability density and gives slightly lower likelihood
to very low and very high counts than it should. Fixing this is one project for our
next version!

Our specific probability is a linear function of the log-density[^lpd] plus a number for each of the categories
and some of their combinations. In particular we estimate using “alphas” for
state, age, sex, education, race/ethnicity, the combination of age and education, age and race/ethnicity,
education and race, and state and race. For the state factor and all the combination factors,
we use “partial-pooling” which means we allow the model itself to estimate how big an overall
factor these variations should be.

[^lpd]: For modeling, we use logarithmic population density.
Population density in the US varies by several orders of magnitude, from 10s
of people per square mile in the most rural places to over 100,000 per square mile
in the densest places, like New York City. That makes it difficult to use as a
predictor. There are various approaches to “fixing” this. We can classify places
by density, e.g., as rural, suburban and urban. Or we can divide density into
quantiles and use those for modeling. We choose a log-transform to compress
the range, somewhat like using quantiles, but preserve the continuous variation.

We use [Stan](https://mc-stan.org), which then runs a
[Hamiltonian Monte Carlo](https://en.wikipedia.org/wiki/Hamiltonian_Monte_Carlo)
to estimate the parameters. Because of how Monte-Carlo methods work, we end up with
not only our expected parameter values but also their distributions, allowing us to
capture uncertainties. This is also true of post-stratifications,
which then provide us with distributions of outcomes and thus things like confidence intervals.

There’s an important last step. We post-stratify these modeled probabilities
across an entire state, giving the expected number of votes in that state. But
we *know* the actual number of votes recorded in the state and our number won’t usually match
exactly. So we adjust each probability using a technique pioneered by
[Hur & Achen](https://www.aramhur.com/uploads/6/0/1/8/60187785/2013._poq_coding_cps.pdf),
and explained in more detail on pages 9-10 of
[this paper](http://www.stat.columbia.edu/~gelman/research/published/mrp_voterfile_20181030.pdf).
We can apply the same adjustment to our confidence intervals giving us an approximate
confidence interval for the adjusted parameter or post-stratification result.

We do this for turnout and party-preference of voters, where we match to known
vote totals for the candidate of each party.

The final result of all this work is an estimate of the DPL for any state legislative
district in the country along
with the breakdowns necessary to do demographic scenario analysis.
|]
