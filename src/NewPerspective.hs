{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module NewPerspective where

import Data.String.Here (here)

part1 :: Text
part1 = [here|
# New Perspectives
We write this post with almost exactly two weeks to go before the 2024 election. Like the rest of you, we are
somewhere between anxious and terrified. We remain cautiously optimistic about the outcome, while being deeply
unsettled that this election is even close.

This close to the election the work we do finding promising long-shot state-leg districts is done: no-one
is shifting candidates now. If you still have money to donate we *highly* recommend you send it to grassroots
GOTV orgs which focus on voters of color in swing states. They are busy and more in need of funds than ever.
Our favorites are conveniently linked in our
[last fundraising post](https://blueripplepolitics.org/blog/final-push-2024).

In this nervous lull, we're thinking about the future. No matter what happens in this election, there will be more
state-legislative elections and we want Dems to win as many of them as possible. Even when we disagree
with particular candidates omn issues, we want Dems to gain control of chambers, to prevent Republican
super-majorities and to pad Dem majorities so more courageous legislation is possible on things like climate
change, labor, reproductive freedom, LGBTQ+ rights, voting rights, etc.

Our founding inspiration is Caroline Bordeaux's extremely-close 2018 loss (419 votes!) in the previously R+20
7th congressional of Georgia (GA-7), followed in 2020 by a more-comfortable 10,000 vote win (D+1).
(before 2020, GA-7 had been in Republican hands since the 1994 election).
Partly these results reflect the generic house ballot in GA in those
years: that R+20 loss came in an R+10 year, the tossup loss came in a R+1 year and the win also in an R+1 year.
But how did an R+20 district become a tossup, even with a 9-point swing in the generic ballot?
Or, to frame the question differently, what did Ms. Bourdeaux see in 2016 and do that convinced her this was
a winnable race and how did she actualize that insight?

The BlueRipple answer here is that the old GA-7 (now redistricted),
was a lot more D-leaning than it appeared, something Ms. Bordeaux spotted and then worked hard to capitalize on.
A combination of shifting demographics and shifting education polarization made GA-7 a district
which was much closer than the R+20 result in 2016 would indicate. From there candidate quality and ground game
were enough to equalize and then win the district.

The questions Ms. Bordeaux asked about GA-7 are worth asking about every seemingly lopsided
congressional and state-legislative
district in the country. Some districts are genuinely out-of-reach (or safe)
and almost no choice of candidate or amount of
phone-banking and door-knocking will change that, especially in this hyper-polarized era. But others simply
turn out lopsided for various reasons. Maybe the party out of power fails to field a candidate at all (this is
suprisingly common, though less and less so), fields a poorly prepared candidate,
or fails to fund the candidate well enough to have a chance.

Finding good candidates is difficult and time-consuming; supporting them is expensive. Donors and
groups who advise donors and support candidate recruitment traditionally focus largely on districts
where the last election suggests the next one will be close. But this risks missing districts like GA-7.
Who would take a risk on an R+20 district, even if you believe there is a 10-point swing in the
generic ballot?

Our modeling work is aimed at finding just those districts. In principle, this work applies
to congressional districts just like GA-7. In practice, we are confident that there is now sufficient
data work and money that these opportunities are rarely missed at the congressional level. So we are
focused on state-legislative districts. There are thousands of these, many crucial to Democratic
control of state chambers or to curbing Republican super-majorities. It's nearly impossible to
study each in detail.

What we do is simple: we look at the most recent comparable election (Right now that's 2020. For the
2026 cycle we will use 2022), create
a model of voter turnout and voter party-preference for 200 demographic groups in each state.
This model is built from a large voter-file-validated post-election survey.
We use that model to estimate what the Dem vote share would have been in each district if turnout and
preference were like the rest of the state. Then we compare our expectation to what actually happened
in the election.

Usually they are fairly close, which they should be since we use the national and statewide results
as input. Nonetheless, some districts are outliers, places where, given the demographics of the voting-age citizens,
the election result is surprising. Those districts are places with a story worth
understanding. That story may not yield electoral fruit: the incumbent is very popular and well-funded,
making her hard to beat; the district has a particular religious or corporate identity, making the
demographics less predictive; etc. But sometimes the story will be something like the old GA-7, a district
where a good candidate with enough money and party support can unearth a much higher level of support
than what was seen in the previous election.

Our model is not predictive. Demographic voting patterns change a lot between
elections. For instance, before 2016, education was not a particularly strong predictor of voter preference,
but since 2016 it has been, at least for white voters.
A demographic model of the 2012 election would have been very wrong about 2016.
So a demographic model alone cannot predict outcomes in the next
election, at least not without more inputs. This is why the predictive models (like 538 or the economist model)
are poll-based, sometimes using a previous-election demographic model as a starting point (technically a "prior")[^pollWeights].
In some ways our work is the *opposite* of predictive! We are most interested in the placesd where the model missed by
the most. And the model doesn't tell us anything about what caused the mismatch between expectations and results.
For that we would need district-specific exit-polling and that's nonexistent at the state-leg district level.
So all we can do is identify


[^pollWeights]: In fact, even poll-based models can
be thrown off by large shifts in the demographics of voter turnout since the polls need some way to weight their
sampled results to create a hypothetical electorate. This is usually quite a bit more complex than using
a previous election's demographics, but for these weightings, the influence of the prior from the previous election
can be quite large.

|]
