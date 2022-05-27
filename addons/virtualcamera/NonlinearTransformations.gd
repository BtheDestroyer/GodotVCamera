extends Object

class_name NonlinearTransformations

static func linear(x : float):
	return x

static func power_int(x : float, n : int):
	var r = 1
	for i in range(n):
		r *= x
	return r

static func power(x : float, n : float):
	if float(int(n)) == n:
		# n is a whole number
		return power_int(x, int(n))
	else:
		var a = power_int(x, floor(n))
		var b = power_int(x, ceil(n))
		return lerp(a, b, fmod(n, 1.0))

static func smooth_start(x : float, n : float = 2.0):
	return power(x, n)

static func smooth_stop(x : float, n : float = 2.0):
	return 1.0 - smooth_start(1.0 - x, n)

static func smooth_step(x : float, n : float = 2.0, n2 = null):
	if n2 is float or n2 is int:
		return lerp(smooth_start(x, n), smooth_stop(x, n2), x)
	else:
		return lerp(smooth_start(x, n), smooth_stop(x, n), x)
