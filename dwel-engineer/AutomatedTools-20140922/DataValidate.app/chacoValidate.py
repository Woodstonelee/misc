#!/usr/bin/env python
"""
This plot displays the audio spectrum from the microphone.

Based on updating_plot.py
"""
# Major library imports
# import pyaudio
import subprocess
import os
import time
import sys
from numpy import zeros, linspace, short, fromstring, hstack, transpose, fromfile, uint16, mean, dtype,array
from collections import deque

# Enthought library imports
from enthought.chaco.api import OverlayPlotContainer
from enthought.chaco.tools.cursor_tool import CursorTool, BaseCursorTool
from enthought.chaco.default_colormaps import jet
from enthought.enable.api import Window, Component, ComponentEditor, BaseTool
from enthought.traits.api import HasTraits, Instance, DelegatesTo
from enthought.traits.ui.api import Item, Group, View, Handler
from enthought.enable.example_support import DemoFrame, demo_main
from enthought.pyface.timer.api import Timer
from chaco.tools.api import PanTool, ZoomTool, DragZoom
# Chaco imports
from enthought.chaco.api import Plot, ArrayPlotData, HPlotContainer, VPlotContainer, GridPlotContainer

HEADER_SIZE_16 = 5
HEADER_SIZE_32 = (HEADER_SIZE_16+1)/2
WAVE_SIZE_16 = 1599
WAVE_SIZE_32 = (WAVE_SIZE_16+1)/2


#pathVar = '/Users/kuravih/Desktop/untitledfolder/'
#compassFileName = pathVar+'compass_2014-04-21-14-35-04'
#encoderFileName = pathVar+'encoder_2014-04-21-14-35-04'
#waveformFileName = pathVar+'waveform_2014-04-21-14-34'

#waveformFile = open(waveformFileName,'r')
#compassFile = open(compassFileName,'r')
#encoderFile = open(encoderFileName,'r')

PLOTLEN = 1000

# encoderTime = zeros(PLOTLEN)
# encoder1 = zeros(PLOTLEN)
# encoder2 = zeros(PLOTLEN)
#
# compassTime = zeros(PLOTLEN)
# compass1 = zeros(PLOTLEN)
# compass2 = zeros(PLOTLEN)
# compass3 = zeros(PLOTLEN)

encoderTime = deque(zeros(PLOTLEN), PLOTLEN)
encoder1 = deque(zeros(PLOTLEN), PLOTLEN)
encoder2 = deque(zeros(PLOTLEN), PLOTLEN)

compassTime = deque(zeros(PLOTLEN), PLOTLEN)
compass1 = deque(zeros(PLOTLEN), PLOTLEN)
compass2 = deque(zeros(PLOTLEN), PLOTLEN)
compass3 = deque(zeros(PLOTLEN), PLOTLEN)

def processCompass(fileName):
    with open(fileName, 'r') as anglebinfile:
        lines = anglebinfile.readlines()
        anglebinfile.close()

def parseSSIWord(ssiWords):
    #decode the ssi string and gets angle in digital units
    angleDu = [0,0]
    for i,val in enumerate(ssiWords):
        if len(val) == 10:
            binarystr = str(bin(int(val)))
            binary2 = binarystr[:2]+binarystr[2:].zfill(25)
            absval2=int(binary2[2:-5],2)
        if i < 2:
            angleDu[i]=absval2
        else:
            print('error, too many commas per return.')
            continue
    return angleDu








def get_multiple_data():

    data = fromfile(file=waveformFile,dtype=uint16,count=1600)[HEADER_SIZE_16:WAVE_SIZE_16]
    normalized_data0 = (data - mean(data)) / 4.43

    data = fromfile(file=waveformFile,dtype=uint16,count=1600)[HEADER_SIZE_16:WAVE_SIZE_16]
    normalized_data1 = (data - mean(data)) / 4.43

    try:
        compassData = compassFile.readline()
        compassdataLine = compassData[1:-7].split(", '")
        compasstimes = float(compassdataLine[0])
        compassangles = compassdataLine[1].split(",")
        #print([compasstimes,compassangles[0],compassangles[1],compassangles[2]])
        compassDataArray = [compasstimes,float(compassangles[0]),float(compassangles[1]),float(compassangles[2])]
    except:
        compassDataArray = [0,0,0,0]

    try:
        encoderData = encoderFile.readline()
        encoderdataLine = encoderData[1:-5].split(", '*0R0")
        encodertimes = float(encoderdataLine[0])
        encoderangles = parseSSIWord(encoderdataLine[1].split(","))
        #print([encodertimes,encoderangles[0],encoderangles[1]])
        encoderDataArray = [encodertimes,encoderangles[0],encoderangles[1]]
    except:
        encoderDataArray = [0,0,0]

    return (normalized_data0,normalized_data1,compassDataArray,encoderDataArray)


#============================================================================
# Create the Chaco plot.
#============================================================================

def _create_plot_component(obj):

    # Time Series plot
    times = 0.5*linspace(0.0, WAVE_SIZE_16+1, WAVE_SIZE_16+2)
    empty_array = zeros(1)
    # ----------------
    obj.amp_dataA = ArrayPlotData(time=times)
    obj.amp_dataA.set_data('amplitude', empty_array)
    obj.amp_plotA = Plot(obj.amp_dataA)
    obj.amp_plotA.padding = 40
    obj.amp_plotA.plot(("time", "amplitude"), name="Time", color="blue")
    obj.amp_plotA.title = "Laser 1"
    obj.amp_plotA.index_axis.title = 'Time (ns)'
    obj.amp_plotA.value_axis.title = 'Amplitude (mV)'
    time_range = obj.amp_plotA.plots.values()[0][0].value_mapper.range
    # ----------------
    time_range.low = -10
    time_range.high = 120
    # ----------------
    obj.amp_dataB = ArrayPlotData(time=times)
    obj.amp_dataB.set_data('amplitude', empty_array)
    obj.amp_plotB = Plot(obj.amp_dataB)
    obj.amp_plotB.padding = 40
    obj.amp_plotB.plot(("time", "amplitude"), name="Time", color="blue")
    obj.amp_plotB.title = "Laser 2"
    obj.amp_plotB.index_axis.title = 'Time (ns)'
    obj.amp_plotB.value_axis.title = 'Amplitude (mV)'
    time_range = obj.amp_plotB.plots.values()[0][0].value_mapper.range
    # ----------------
    time_range.low = -10
    time_range.high = 120

    # ----------------
    obj.encoder_data = ArrayPlotData()
    obj.encoder_data.set_data("time", empty_array)
    obj.encoder_data.set_data("encoder1", empty_array)
    obj.encoder_data.set_data("encoder2", empty_array)
    obj.encoder_plot = Plot(obj.encoder_data)
    obj.encoder_plot.padding = 40
    obj.encoder_plot.plot(("time","encoder1"), name="encoder1", color="blue")
    obj.encoder_plot.plot(("time","encoder2"), name="encoder2", color="red")
    obj.encoder_plot.title = "Encoders"
    obj.encoder_plot.index_axis.title = 'Time (s)'
    obj.encoder_plot.value_axis.title = 'Encoders (du)'
    time_range = obj.encoder_plot.plots.values()[0][0].value_mapper.range
    # ----------------
    time_range.low = 0
    time_range.high = 2**19





    # ----------------
    obj.compass_data = ArrayPlotData(time=times)
    obj.compass_data.set_data("time", empty_array)
    obj.compass_data.set_data("compass1", empty_array)
    obj.compass_data.set_data("compass2", empty_array)
    obj.compass_data.set_data("compass3", empty_array)
    obj.compass_plot = Plot(obj.compass_data)
    obj.compass_plot.padding = 40
    obj.compass_plot.plot(("time","compass1"), name="compass1", color="red")
    obj.compass_plot.plot(("time","compass2"), name="compass2", color="blue")
    obj.compass_plot.plot(("time","compass3"), name="compass3", color="green")
    obj.compass_plot.title = "Compass (tilts x10)"
    obj.compass_plot.index_axis.title = 'Time (s)'
    obj.compass_plot.value_axis.title = 'Compass (degrees)'
    time_range = obj.compass_plot.plots.values()[0][0].value_mapper.range
    # ----------------
    time_range.low = -10
    time_range.high = 360

    obj.INDEX = 0
    obj.compassZeroTime = 0
    obj.encoderZeroTime = 0



    container = VPlotContainer()
    container.add(obj.encoder_plot)
    container.add(obj.compass_plot)
    container.add(obj.amp_plotA)
    container.add(obj.amp_plotB)



    return container


class TimerController(HasTraits):

    def onTimer(self, *args):
        #spectrum, time = get_audio_data()
        ampA, ampB, compassData, encoderData = get_multiple_data()

        if (self.INDEX == 0):
            self.compassZeroTime = compassData[0]
            self.encoderZeroTime = encoderData[0]

        self.amp_dataA.set_data('amplitude', ampA)
        self.amp_dataB.set_data('amplitude', ampB)

        if not(encoderData ==[0,0,0]):
            encoderTime.append(encoderData[0]-self.encoderZeroTime)
            encoder1.append(encoderData[1])
            encoder2.append(encoderData[2])

            self.encoder_data.set_data('time', array(encoderTime))
            self.encoder_data.set_data('encoder1', array(encoder1))
            self.encoder_data.set_data('encoder2', array(encoder2))

        if not(compassData ==[0,0,0,0]):
            compassTime.append(compassData[0]-self.compassZeroTime)
            compass1.append(compassData[1])
            compass2.append(compassData[2]*10)
            compass3.append(compassData[3]*10)

            self.compass_data.set_data('time', array(compassTime))
            self.compass_data.set_data('compass1', array(compass1))
            self.compass_data.set_data('compass2', array(compass2))
            self.compass_data.set_data('compass3', array(compass3))

        self.INDEX+=1

        return

#============================================================================
# Attributes to use for the plot view.
size = (900,600)
title = "Laser Returns"

#============================================================================
# Demo class that is used by the demo.py application.
#============================================================================

class DemoHandler(Handler):

    def closed(self, info, is_ok):
        """ Handles a dialog-based user interface being closed by the user.
        Overridden here to stop the timer once the window is destroyed.
        """
        info.object.timer.Stop()
        return

class Demo(HasTraits):

    plot = Instance(Component)

    controller = Instance(TimerController, ())

    timer = Instance(Timer)

    # traits_view = View(
    #                 Group(
    #                     Item('plot', editor=ComponentEditor(size=size),
    #                          show_label=False),
    #                     orientation = "horizontal"),
    #                 resizable=True, title=title,
    #                 width=size[0], height=size[1],
    #                 handler=DemoHandler
    #                 )

    def __init__(self, **traits):
        super(Demo, self).__init__(**traits)
        self.plot = _create_plot_component(self.controller)

    def edit_traits(self, *args, **kws):
        # Start up the timer! We should do this only when the demo actually
        # starts and not when the demo object is created.
        self.timer = Timer(1, self.controller.onTimer)
        return super(Demo, self).edit_traits(*args, **kws)

    def configure_traits(self, *args, **kws):
        # Start up the timer! We should do this only when the demo actually
        # starts and not when the demo object is created.
        self.timer = Timer(1, self.controller.onTimer)
        return super(Demo, self).configure_traits(*args, **kws)

popup = Demo()


#============================================================================
# Stand-alone frame to display the plot.
#============================================================================

from enthought.etsconfig.api import ETSConfig

if ETSConfig.toolkit == "wx":

    import wx
    class PlotFrame(DemoFrame):

        def _create_window(self):

            self.controller = TimerController()
            container = _create_plot_component(self.controller)
            # Bind the exit event to the onClose function which will force the
            # example to close. The PyAudio package causes problems that normally
            # prevent the user from closing the example using the 'X' button.
            # NOTE: I believe it is sufficient to just stop the timer-Vibha.
            self.Bind(wx.EVT_CLOSE, self.onClose)

            # Set the timer to generate events to us
            timerId = wx.NewId()
            self.timer = wx.Timer(self, timerId)
            self.Bind(wx.EVT_TIMER, self.controller.onTimer, id=timerId)
            self.timer.Start(20.0, wx.TIMER_CONTINUOUS)

            # Return a window containing our plots
            return Window(self, -1, component=container)

        def onClose(self, event):
            #sys.exit()
            self.timer.Stop()
            event.Skip()

elif ETSConfig.toolkit == "qt4":

    from enthought.qt import QtGui, QtCore

    class PlotFrame(DemoFrame):
        def _create_window(self):
            self.controller = TimerController()
            container = _create_plot_component(self.controller)

            # start a continuous timer
            self.timer = QtCore.QTimer()
            self.timer.timeout.connect(self.controller.onTimer)
            self.timer.start(20)

            return Window(self, -1, component=container)

        def closeEvent(self, event):
            # stop the timer
            if getattr(self, "timer", None):
                self.timer.stop()
            return super(PlotFrame, self).closeEvent(event)

if __name__ == "__main__":
    waveformFileName = sys.argv[1]
    encoderFileName = sys.argv[2]
    compassFileName = sys.argv[3]
    waveformFile = open(waveformFileName,'r')
    compassFile = open(compassFileName,'r')
    encoderFile = open(encoderFileName,'r')
    demo_main(PlotFrame, size=size, title=title)