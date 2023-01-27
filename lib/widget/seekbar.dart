import 'dart:math';

import 'package:brook/util/utils.dart';
import 'package:flutter/material.dart';

class SeekBarData {
  final Duration position;
  final Duration duration;

  SeekBarData(this.position, this.duration);
}

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  const SeekBar({
    Key? key,
    required this.position,
    required this.duration,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;

  String formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    }
    String minutes = (duration.inSeconds ~/ 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(
                  disabledThumbRadius: 4,
                  enabledThumbRadius: 4,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 10,
                ),
                activeTrackColor: Colors.white.withOpacity(0.2),
                inactiveTrackColor: Colors.white,
                thumbColor: Colors.white,
                overlayColor: Colors.white,
              ),
              child: Slider(
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble(),
                ),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                  vlog.i(value);
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                  setState(() {
                    _dragValue = null;
                  });
                  vlog.i(value);
                },
              ),
            ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(widget.position),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
              Text(
                formatDuration(widget.duration),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
