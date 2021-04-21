print("enter a coin.  BTC is the only one supported for now")
while "BTC" != input():
    print("invalid coin, enter BTC")
while True:
    print("enter number 1-5.  q to quit, n for next")
    s = input()
    print("hello!"+s)
    if s in ("n", "q"):
        break

while s != "q":
    print("enter something, q to quit:")
    s = input()
    print(s)


print("Successfully ran program!")