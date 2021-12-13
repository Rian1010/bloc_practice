

// By marking a function as async* we are able to use the yield keyword and return a Stream of data.
Stream<int> countStream(int max) async* {
	for (int i = 0; i < max; i++) |
		yield I;
	}
}

Future<int> sumStream(Stream<int> stream) async {
	int sum = 0;
	await for (int value in stream) {
		sum += value;
	}
	return sum;
}

void main() async {
	/// Initialise a stream of integers 0-9
	Stream<int> stream = countStream(10);

	/// Compute the sum of the stream of integers
	int sum = await sumStream(stream); 

	print(sum); // 45
}



// Creating a Cubit

// class CounterCubit extends Cubit<int> {
//	CounterCubit(int initialState) : super(0);
// } 

// final cubitA = CounterCubit(0); // state starts at 0
// final cubitB = CounterCubit(10); // state starts at 10

class CounterCubit extends Cubit<int> {
	CounterCubit() : super(0);
	
	void increment() {
		addError(Exception('increment error!'), StackTrace.current);
		emit(state + 1);
	}

	// We can observe all changes for a given Cubit by overriding onChange
	@override
	void onChange(Change<int> change) {
		print(change);
		super.onChange(change);
	}

	@override
	void onError(Object error, StackTrace stackTrace) {
		print('$error, $stackTrace');
		super.onError(error, stackTrace);
	}
} 

void main() {
	final cubit = CounterCubit();
	print(cubit.state); // 0
	cubit.increment();
	print(cubit.state) // 1
	cubit.close();


}



// Stream Usage

Future<void> main() async {
	final cubit = CounterCubit();
	// Subscribing to the CounterCubit and calling print on each state
	final subscription = cubit.stream.listen(print); // 1

	cubit.increment();

	await Future.delayed(Duration.zero);

	await subscription.cancel();
	await cubit.close();
}



// Observing a Cubit
Void main() {
	CounterCubit()
	  ..increment()
	  ..close();
}

// Note: A Change occurs just before the state of the Cubit is updated. A Change consists of the currentState and the nextState



// BlocObserver 
// (to manage many Cubits in large applications)

class SimpleBlocObserver extends  BlocObserver {
	@override 
	void onChange(BlocBase bloc, Change change) {
		super.onChange(bloc, change);
		print('${bloc.runtimeType} $change');
	}
}

Void main() {
	BlocOverrides.runZoned(
		() {
			CounterCubit()
			  ..increment()
			  ..close();
		},
		blocObserver: SimpleBlocObserver(),
	);
}














